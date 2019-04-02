resource "local_file" "eks_config" {
    content     = "${module.eks_cluster.kubeconfig}"
    filename = "kubeconfig"
}
resource "null_resource" "makeKubeConfig" {
  triggers { 
    template = "${local_file.eks_config.content}"
  }
  provisioner "local-exec" {
    command = "cp kubeconfig ~/.kube/config-${module.workspaces.env}"
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
                
                export KUBECONFIG=~/.kube/config-${module.workspaces.env}
                kubectl config set-context aws-${module.workspaces.env}

                kubectl apply -f config_map_aws_auth.yml
                kubectl create -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v1.10/nvidia-device-plugin.yml

                if [ "${module.workspaces.env}" == "tools" ]; then
                  export KUBEFLOW_SRC=kubeflow
                  export KFAPP=eks-kubeflow
                  cd ../$${KUBEFLOW_SRC}
                  [[ -d $${KFAPP} ]] || ./scripts/kfctl.sh init $${KFAPP} --platform none
                  cd $${KFAPP}
                  ../scripts/kfctl.sh generate k8s
                  ../scripts/kfctl.sh apply k8s

                  ARGO_CD_LATEST=$$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
                  kubectl create namespace argocd
                  kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/$ARGO_CD_LATEST/manifests/install.yaml
                  kubectl create clusterrolebinding MikeMainguy-cluster-admin-binding --clusterrole=cluster-admin --user=mnmainguy1@gmail.com
                fi

              EOT
  }
}