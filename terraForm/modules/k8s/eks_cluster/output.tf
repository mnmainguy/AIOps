locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.eks_cluser_prod.endpoint}
    certificate-authority-data: ${aws_eks_cluster.eks_cluser_prod.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
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
  value = "${aws_eks_cluster.eks_cluser_prod.id}"
}

output "aws_eks_version" {
  value = "${aws_eks_cluster.eks_cluser_prod.version}"
}

locals {
  eks_node_userdata = <<USERDATA
                        #!/bin/bash
                        set -o xtrace
                        /etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks_cluser_prod.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks_cluser_prod.certificate_authority.0.data}' '${var.cluster_name}'
                        
                        
                        export GITHUB_TOKEN="${var.eks_git_token}"
                        export KUBEFLOW_TAG=v0.4.1
                        export KUBEFLOW_SRC=/tmp/kubeflow_src
                        export KFAPP=eks-kubeflow
                        mkdir $${KUBEFLOW_SRC} && cd $${KUBEFLOW_SRC}
                        curl https://raw.githubusercontent.com/kubeflow/kubeflow/$${KUBEFLOW_TAG}/scripts/download.sh | bash

                        $${KUBEFLOW_SRC}/scripts/kfctl.sh init $${KFAPP} --platform none
                        cd $${KFAPP}
                        $${KUBEFLOW_SRC}/scripts/kfctl.sh generate k8s
                        $${KUBEFLOW_SRC}/scripts/kfctl.sh apply k8s

                        USERDATA
}

output "eks_node_userdata" {
  value = "${local.eks_node_userdata }"
}