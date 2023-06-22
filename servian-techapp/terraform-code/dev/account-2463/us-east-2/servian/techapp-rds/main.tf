data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "${var.account_name}-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "sg-rds" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "${var.account_name}-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/security-group/sg-rds/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "sns-arn" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "${var.account_name}-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/aws-sns/terraform.tfstate"
    region = "us-east-1"
  }
}
# Below path is created in vault during initial configuration.
data "vault_generic_secret" "vault_secrets" {
  path = "secrets/techapp,dev"
}

module "db" {
  source = "/mnt/c/personal/MT/servian-techapp/iac-module-aws/data-stores/rds"

  identifier = "techapp-${var.env_name}"

  engine            = "postgres"
  engine_version    = "9.6.24"
  instance_class    = "db.m5.large"
  allocated_storage = 20
  storage_encrypted = true
  multi_az = false


  #kms_key_id        = "arn:aws:kms:${var.aws_region}:${var.aws_account_id}:key/22eb52cb-3aea-4084-bbbe-fb7b7c5ece4a"
  name = "techapp_${var.env_name}"


  username = data.vault_generic_secret.vault_secrets.data["dbusername"]
  password = data.vault_generic_secret.vault_secrets.data["dbpassword"]
  port     = "5432"

  vpc_security_group_ids = [data.terraform_remote_state.sg-rds.outputs.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster  9o5tGre$
  backup_retention_period = 7

  tags = {
    Name = "techapp_${var.env_name}"
    Environment = var.env_name
    Project_Name= var.project_name
    Deployed_by  = "riyajkazi"
    Email        = "riyazikazi@gmail.com"
  }

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # DB subnet group
  # subnet_ids = data.aws_subnet_ids.all.ids
  subnet_ids = data.terraform_remote_state.vpc.outputs.database_subnets

  # DB parameter group
  family = "postgres9.6"

  # DB option group
  major_engine_version = "9.6"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "techapp-${var.env_name}-snapshot"

  # Database Deletion Protection
  deletion_protection = true

   # AWS alerts
  create_alerts = var.create_alerts
  aws_sns_arn = data.terraform_remote_state.sns-arn.outputs.sns_topic_arn
  deployment_env = var.env_name

}
