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
  depends_on = ["null_resource.makeKubeConfig","module.eks_worker"]
  triggers { 
    template = "${local_file.config_map_aws_auth.content}"
  }
  provisioner "local-exec" {
    command = <<EOT
                
                # Source profile for ks and argocd commands if needed
                . ~/.profile

                # Set KUBECONFIG to current environment
                export KUBECONFIG=$$HOME/.kube/config-${module.workspaces.env}
                kubectl config set-context aws-${module.workspaces.env}

                # Apply aws authentication and GPU driver to cluser (if needed)
                kubectl apply -f config_map_aws_auth.yml
                # kubectl create -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v1.10/nvidia-device-plugin.yml

                # Create namespaces for kubeflow and model
                kubectl create namespace kubeflow
                kubectl create namespace mnist

                # Create kubectl secrets for S3 connection
                kubectl create secret generic aws-creds -n mnist --from-literal=awsAccessKeyID=${var.access_key}   --from-literal=awsSecretAccessKey=${var.secret_key}

                cd ../setup_ks_apps

                # If workspace is train
                if test "${module.workspaces.env}" = 'train'; then
                  kubectl create namespace argocd
                  kubectl create namespace argo
                  kubectl create namespace test

                  # Add server details to setup_ks_apps/app.yaml file
                  ks env set argo-train --server="${module.eks_cluster.eks_cluster_endpoint}"
                  ks env set argocd-train --server="${module.eks_cluster.eks_cluster_endpoint}"
                  ks env set kubeflow-train --server="${module.eks_cluster.eks_cluster_endpoint}"
                  ks env set mnist-train --server="${module.eks_cluster.eks_cluster_endpoint}"
                  ks env set mnist-test --server="${module.eks_cluster.eks_cluster_endpoint}"

                  # Deploy argocd and argo to training environment
                  ks apply argocd-${module.workspaces.env}
                  ks apply argo-${module.workspaces.env}

                  # Create storage and credentials for docker cache
                  kubectl create secret generic docker-creds -n mnist --from-literal=dockerLogin=${var.docker_login} --from-literal=dockerPassword=${var.docker_password}
                  kubectl create secret generic aws-creds -n test --from-literal=awsAccessKeyID=${var.access_key}   --from-literal=awsSecretAccessKey=${var.secret_key}

                  sleep 1m
                  # Login to Argocd and create deployment plans for training deployments
                  ARGOCD_URL="$$(kubectl get service -n argocd argocd-server -o jsonpath="{.status.loadBalancer.ingress[*].hostname}")" 
                  ARGOCD_PW="$$(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2)"
                  argocd login $$ARGOCD_URL --insecure --username=admin --password=$$ARGOCD_PW
                  argocd app create argo-train -f ../setup_argocd/argo-train.yaml
                  argocd app create kubeflow-train -f ../setup_argocd/kubeflow-train.yaml
                  argocd app create mnist-train -f ../setup_argocd/mnist-train.yaml
                  argocd app create mnist-prod -f ../setup_argocd/mnist-prod.yaml

                fi
                
                # If workspace is prod
                if test "${module.workspaces.env}" = 'prod'; then

                  # Add server details to setup_ks_apps/app.yaml file
                  ks env set kubeflow-prod --server="${module.eks_cluster.eks_cluster_endpoint}"
                  ks env set mnist-prod --server="${module.eks_cluster.eks_cluster_endpoint}"

                  # Login to Argocd and create deployment plans for production deployments
                  ARGOCD_URL="$$(kubectl get service -n argocd argocd-server -o jsonpath="{.status.loadBalancer.ingress[*].hostname}")" 
                  ARGOCD_PW="$$(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2)"
                  argocd login $$ARGOCD_URL --insecure --username=admin --password=$$ARGOCD_PW
                  argocd cluster add aws-prod
                  argocd app create kubeflow-prod -f ../setup_argocd/kubeflow-prod.yaml --env kubeflow-prod
                  argocd app create mnist-prod -f ../setup_argocd/mnist-prod.yaml --env mnist-prod

                fi

                # Deploy kubeflow to training and prod environments
                ks apply kubeflow-${module.workspaces.env}
                
              EOT
  }
}