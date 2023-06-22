resource "kubernetes_namespace" "namespace" {
  metadata {
    annotations = {
      name = "namespace-annotation"
    }
    labels = {
      mylabel = "namespace"
    }
    name = var.kubernetes_namespace
  }
}