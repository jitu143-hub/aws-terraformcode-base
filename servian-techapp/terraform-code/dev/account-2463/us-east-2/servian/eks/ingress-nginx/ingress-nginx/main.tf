resource "helm_release" "ingress-nginx" {
    name = "ingress-nginx"
    chart = "ingress-nginx"
    namespace = "ingress-nginx"
    version = "3.23.0"
    repository = "https://kubernetes.github.io/ingress-nginx"

    values = [
    "${file("values.yaml")}"
    ]


}