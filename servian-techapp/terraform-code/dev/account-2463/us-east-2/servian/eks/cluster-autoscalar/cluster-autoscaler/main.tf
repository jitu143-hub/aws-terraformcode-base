resource "helm_release" "autoscaler" {
  name       = "autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "cluster-autoscaler"
  version    = "9.9.2"
  repository = "https://kubernetes.github.io/autoscaler"

  values = [
    "${file("values.yaml")}"
  ]

  set {
    name = "fullnameOverride"
    value = var.autoscalar_name
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = "${var.env_name}-${var.eks_cluster_name}"
  }

  set {
    name = "awsRegion"
    value = var.aws_region
  }

  set {
    name = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.servian_cluster_autoscaler_sa_role.this_iam_role_arn
  }
}

module "servian_cluster_autoscaler_sa_role" {
  source       = "/mnt/c/personal/MT/servian-techapp/iac-module-aws/iam/iam-assumable-role-with-oidc"
  create_role  = true
  role_name    = "reef-${var.env_name}-cluster-autoscaler-sa-role"
  provider_url = var.oidc_provider
  role_policy_arns = [
    var.role_policy_arn,
  ]
  oidc_fully_qualified_subjects = [
    "system:serviceaccount:${var.namespace}:${var.autoscalar_name}",
  ]
}
