resource "kubernetes_namespace" "mongodb" {
  metadata {
    name = "mongodb"
  }
}

# Configuração de rede para usar a mesma VPC e Security Group do cluster EKS
resource "kubernetes_persistent_volume_claim" "mongodb" {
  metadata {
    name      = "mongodb-pvc"
    namespace = kubernetes_namespace.mongodb.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "gp2"  # ou o storage class que você está usando

    resources {
      requests = {
        storage = "20Gi"
      }
    }
  }
}

resource "kubernetes_deployment" "mongodb" {
  metadata {
    name      = "mongodb"
    namespace = kubernetes_namespace.mongodb.metadata[0].name
    labels = {
      app = "mongodb"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mongodb"
      }
    }

    template {
      metadata {
        labels = {
          app = "mongodb"
        }
      }

      spec {
        container {
          name  = "mongodb"
          image = "mongo:6.0.10"

          resources {
            requests {
              memory = "512Mi"
              cpu    = "250m"
            }
            limits {
              memory = "1Gi"
              cpu    = "500m"
            }
          }

          volume_mount {
            mount_path = "/data/db"
            name       = "mongodb-pvc"
          }

          env {
            name  = "MONGO_INITDB_ROOT_USERNAME"
            value = "dev_user"
          }

          env {
            name  = "MONGO_INITDB_ROOT_PASSWORD"
            value = var.mongodb_admin_password
          }

          ports {
            container_port = 27017
          }
        }

        volume {
          name = "mongodb-pvc"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.mongodb.metadata[0].name
          }
        }

        # Configuração de rede para usar a mesma VPC e Security Group do cluster EKS
        node_selector {
          "beta.kubernetes.io/arch" = "amd64"
        }

        tolerations {
          key      = "node-role.kubernetes.io/control-plane"
          operator = "Exists"
          effect   = "NoSchedule"
        }
      }
    }
  }
}

resource "kubernetes_service" "mongodb" {
  metadata {
    name      = "mongodb"
    namespace = kubernetes_namespace.mongodb.metadata[0].name
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
    }
  }

  spec {
    selector = {
      app = "mongodb"
    }

    port {
      port        = 27017
      target_port = 27017
    }

    type = "LoadBalancer"
  }
}

# Configuração adicional para permitir acesso do cluster EKS
resource "kubernetes_network_policy" "mongodb" {
  metadata {
    name      = "allow-eks-access"
    namespace = kubernetes_namespace.mongodb.metadata[0].name
  }

  spec {
    pod_selector {
      match_labels = {
        app = "mongodb"
      }
    }

    ingress {
      from {
        namespace_selector {
          match_labels = {
            name = var.eks_cluster
          }
        }
      }

      ports {
        port     = 27017
        protocol = "TCP"
      }
    }
  }
}

output "mongodb_endpoint" {
  value = kubernetes_service.mongodb.status[0].load_balancer[0].ingress[0].hostname
}

output "mongodb_service_name" {
  value = kubernetes_service.mongodb.metadata[0].name
}

output "mongodb_namespace" {
  value = kubernetes_namespace.mongodb.metadata[0].name
}
