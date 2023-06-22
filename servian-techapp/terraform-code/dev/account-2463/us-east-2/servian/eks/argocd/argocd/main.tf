resource "helm_release" "argocd" {
    name = "argocd"
    chart = "argo-cd"
    namespace = "argocd"
    version = "3.6.8"
    repository = "https://argoproj.github.io/argo-helm"

    values = [
    "${file("values.yaml")}"
    ]
}