data "terraform_remote_state" "eks" {
  backend = "local"

  config = {
    path = "../aws-eks-terraform/terraform.tfstate"
  }
}

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.cluster.name
    ]
  }
}

resource "kubernetes_deployment" "my_app" {
  metadata {
    name = "my-app"
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "my-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "my-app"
        }
      }

      spec {
        container {
          image = "jyotisubhra/todosh2:v1"
          name  = "my-app"

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "my_nlb_service" {
  metadata {
    name = "my-nlb-service"

    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
    }
  }

  spec {
    selector = {
      app = kubernetes_deployment.my_app.spec[0].template[0].metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 8080
      protocol    = "TCP"
      name        = "http"
    }

    type = "LoadBalancer"
  }
}