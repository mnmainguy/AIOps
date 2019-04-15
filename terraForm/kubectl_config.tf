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

                if test "${module.workspaces.env}" = 'train'; then
                  kubectl create namespace argocd
                  kubectl create namespace argo

                  ks env set argo-train --server="${module.eks_cluster.eks_cluster_endpoint}"
                  ks env set argocd-train --server="${module.eks_cluster.eks_cluster_endpoint}"
                  ks env set kubeflow-train --server="${module.eks_cluster.eks_cluster_endpoint}"
                  ks env set mnist-train --server="${module.eks_cluster.eks_cluster_endpoint}"

                  ks apply argocd-${module.workspaces.env}
                  ks apply argo-${module.workspaces.env}

                  ARGOCD_URL="$$(kubectl get service -n argocd argocd-server -o jsonpath="{.status.loadBalancer.ingress[*].hostname}")" 
                  ARGOCD_PW="$$(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2)"
                  argocd login $$ARGOCD_URL --insecure --username=admin --password=$$ARGOCD_PW
                  argocd app create argo-train -f ../setup_argocd/argo-train.yaml
                  argocd app create kubeflow-train -f ../setup_argocd/kubeflow-train.yaml
                  argocd app create mnist-train -f ../setup_argocd/mnist-train.yaml

                fi
                
                if test "${module.workspaces.env}" = 'prod'; then
                  ks env set kubeflow-prod --server="${module.eks_cluster.eks_cluster_endpoint}"
                  ks env set mnist-prod --server="${module.eks_cluster.eks_cluster_endpoint}"

                  ARGOCD_URL="$$(kubectl get service -n argocd argocd-server -o jsonpath="{.status.loadBalancer.ingress[*].hostname}")" 
                  ARGOCD_PW="$$(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2)"
                  argocd login $$ARGOCD_URL --insecure --username=admin --password=$$ARGOCD_PW
                  argocd cluster add aws-prod
                  argocd app create kubeflow-prod -f ../setup_argocd/kubeflow-prod.yaml --env aws-prod
                  argocd app create mnist-prod -f ../setup_argocd/mnist-prod.yaml --env aws-prod

                fi

                ks apply kubeflow-${module.workspaces.env}
                
              EOT
  }
}