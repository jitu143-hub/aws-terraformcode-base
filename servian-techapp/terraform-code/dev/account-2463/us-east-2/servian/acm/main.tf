
data "aws_route53_zone" "this" {
  count = var.use_existing_route53_zone ? 1 : 0

  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_zone" "this" {
  count = !var.use_existing_route53_zone ? 1 : 0
  name  = var.domain_name
}

module "acm" {
  source = "/mnt/c/personal/MT/servian-techapp/iac-module-aws/aws-acm"

  domain_name = var.domain_name
  zone_id     = coalescelist(data.aws_route53_zone.this.*.zone_id, aws_route53_zone.this.*.zone_id)[0]

  subject_alternative_names = [
    "*.${var.domain_name}"

  ]

  wait_for_validation = true

  tags = {
    Name = var.domain_name
    Project_Name= var.project_name
    Deployed_by  = "riyajkazi"
    Email        = "riyazikazi@gmail.com"
  }
}