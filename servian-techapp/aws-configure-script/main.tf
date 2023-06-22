resource "null_resource" "creating-aws-profile" {
  provisioner "local-exec" {
    command = <<EOT
     aws configure set aws_access_key_id ${var.AWS_ACCESS_KEY_ID} --profile ${var.profile_name} &&
     aws configure set aws_secret_access_key ${var.AWS_SECRET_ACCESS_KEY} --profile ${var.profile_name} &&
     aws configure set profile.${var.profile_name}.region ${var.aws-region}
     export AWS_PROFILE=${var.profile_name} 
  EOT
  }
}