data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "${var.account_name}-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_security_group" "eks-nodes-sg" {
  name        = "sg_for_eks_nodes_${var.env_name}_${var.project_name}"
  description = "security group for eks nodes "
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Vault"
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description = "argocd"
    from_port   = 8083
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "public and private cidr"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.private_subnets_cidr_blocks[0],
      data.terraform_remote_state.vpc.outputs.private_subnets_cidr_blocks[1],
      data.terraform_remote_state.vpc.outputs.private_subnets_cidr_blocks[2],
      data.terraform_remote_state.vpc.outputs.public_subnets_cidr_blocks[2],
      data.terraform_remote_state.vpc.outputs.public_subnets_cidr_blocks[1],
      data.terraform_remote_state.vpc.outputs.public_subnets_cidr_blocks[0]

    ]
  }

  ingress {
    description = "ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_for_eks_nodes_${var.env_name}_${var.project_name}"
    Environment = var.env_name
    Project_Name= var.project_name
    Deployed_by  = "riyajkazi"
    Email        = "riyazikazi@gmail.com"
  }
}