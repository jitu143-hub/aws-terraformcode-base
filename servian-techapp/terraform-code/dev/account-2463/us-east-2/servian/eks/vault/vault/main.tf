resource "helm_release" "vault" {
  name       = "vault"
  chart      = "vault"
  namespace  = "vault"
  version    = "0.13.0"
  repository = "https://helm.releases.hashicorp.com"
  # force_update = true

  values = [
    "${file("values.yaml")}"
  ]

}

