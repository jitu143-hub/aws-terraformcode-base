resource "tls_private_key" "this" {
  algorithm = "RSA"
}

resource "aws_key_pair" "this" {
  key_name   = var.key_name     
  public_key = tls_private_key.this.public_key_openssh

  tags = {
    Name          = var.key_name
    Environment   = var.env_name
    Project_Name  = var.project_name
    Deployed_by   = "riyajkazi"
    Email         = "riyazikazi@gmail.com"
  }
  provisioner "local-exec" { # Create a "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.this.private_key_pem}' > ../../../${var.key_name}.pem"
  }

}
