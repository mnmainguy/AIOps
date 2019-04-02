locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.eks_cluser.endpoint}
    certificate-authority-data: ${aws_eks_cluster.eks_cluser.certificate_authority.0.data}
  name: kubernetes-${var.aiops_env}
contexts:
- context:
    cluster: kubernetes-${var.aiops_env}
    user: aws-${var.aiops_env}
  name: aws-${var.aiops_env}
current-context: aws-${var.aiops_env}
kind: Config
preferences: {}
users:
- name: aws-${var.aiops_env}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.cluster_name}"
KUBECONFIG
}

output "kubeconfig" {
  value = "${local.kubeconfig}"
}

data "aws_iam_role" "eks_nodes_role_name" {
  name = "${var.eks_nodes_role_name}"
}

locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${data.aws_iam_role.eks_nodes_role_name.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH
}

output "config_map_aws_auth" {
  value = "${local.config_map_aws_auth}"
}

output "aws_eks_id" {
  value = "${aws_eks_cluster.eks_cluser.id}"
}

output "aws_eks_version" {
  value = "${aws_eks_cluster.eks_cluser.version}"
}

locals {
  eks_node_userdata = <<USERDATA
                        #!/bin/bash
                        set -o xtrace
                        /etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks_cluser.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks_cluser.certificate_authority.0.data}' '${var.cluster_name}'
                        
                        if [ "${var.aiops_env}" == "tools" ]; then
                          export KS_VER=0.13.1
                          export KS_PKG=ks_$${KS_VER}_linux_amd64
                          wget -O /tmp/$${KS_PKG}.tar.gz https://github.com/ksonnet/ksonnet/releases/download/v$${KS_VER}/$${KS_PKG}.tar.gz
                          mkdir -p $${HOME}/bin
                          tar -xvf /tmp/$$KS_PKG.tar.gz -C $${HOME}/bin
                          export PATH=$$PATH:$${HOME}/bin/$$KS_PKG 
                          echo 'export PATH=/usr/local/bin:$$PATH' >>~/.profile
                        fi

                        USERDATA
}

output "eks_node_userdata" {
  value = "${local.eks_node_userdata }"
}