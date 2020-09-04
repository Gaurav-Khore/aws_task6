provider "kubernetes" {}


resource "kubernetes_deployment" "word_launch" {
  metadata {
    name = "my-word"
    labels = {
      test = "myword"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        test = "myword"
      }
    }

    template {
      metadata {
        labels = {
          test = "myword"
        }
      }

      spec {
        container {
          image = "wordpress"
          name  = "myword"
        }
      }
    }
  }
}

resource "kubernetes_service" "wordlb" {
  metadata {
    name = "wordlb"
  }
  spec {
    selector = {
      test = "${kubernetes_deployment.word_launch.metadata.0.labels.test}"
    }
    port {
      port = 80
      target_port = 80
    }

    type = "NodePort"
  }
}


resource "null_resource" "url" {
 provisioner "local-exec" {
  command = "minikube service list"
 }
 
depends_on = [ kubernetes_service.wordlb ]

}