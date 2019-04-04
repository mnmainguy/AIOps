resource "local_file" "eks_config" {
    content     = "${module.eks_cluster.kubeconfig}"
    filename = "kubeconfig"
}
resource "null_resource" "makeKubeConfig" {
  triggers { 
    template = "${local_file.eks_config.content}"
  }
  provisioner "local-exec" {
    command = "cp kubeconfig $$HOME/.kube/config-${module.workspaces.env}"
  }
}
resource "local_file" "config_map_aws_auth" {
    content     = "${module.eks_cluster.config_map_aws_auth}"
    filename = "config_map_aws_auth.yml"
}
resource "null_resource" "ApplyAWSCredentials" {
  depends_on = ["null_resource.makeKubeConfig"]
  triggers { 
    template = "${local_file.config_map_aws_auth.content}"
  }
  provisioner "local-exec" {
    command = <<EOT

                . ~/.profile
                export KUBECONFIG=$$HOME/.kube/config-${module.workspaces.env}
                kubectl config set-context aws-${module.workspaces.env}

                kubectl apply -f config_map_aws_auth.yml
                kubectl create -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v1.10/nvidia-device-plugin.yml

                kubectl create namespace kubeflow
                kubectl create namespace mnist

                kubectl create secret generic aws-creds -n mnist --from-literal=awsAccessKeyID=${var.access_key}   --from-literal=awsSecretAccessKey=${var.secret_key}

                cd ../setup_ks_apps
                ks apply kubeflow-${module.workspaces.env}

                if [ "${module.workspaces.env}" == "train" ]; then
                  kubectl create namespace argocd
                  kubectl create namespace argo
                  ks apply argocd-${module.workspaces.env}
                  ks apply argo-${module.workspaces.env}
                
                fi
                
              EOT
  }
}