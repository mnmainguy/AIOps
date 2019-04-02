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
                
                export KUBECONFIG=$${KUBECONFIG:+$${KUBECONFIG}:}config-${module.workspaces.env}
                kubectl config set-context=aws-${module.workspaces.env}

                kubectl apply -f config_map_aws_auth.yml
                kubectl create -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v1.10/nvidia-device-plugin.yml

                if [ "${module.workspaces.env}" == "TOOLS" ]; then
                  export KUBEFLOW_SRC=kubeflow
                  export KFAPP=eks-kubeflow
                  cd ../$${KUBEFLOW_SRC}
                  $${KUBEFLOW_SRC}/scripts/kfctl.sh init $${KFAPP} --platform none
                  cd $${KFAPP}
                  $${KUBEFLOW_SRC}/scripts/kfctl.sh generate k8s
                  $${KUBEFLOW_SRC}/scripts/kfctl.sh apply k8s
                fi

              EOT
  }
}