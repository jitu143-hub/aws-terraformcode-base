data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "${var.account_name}-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}
#
resource "aws_iam_role" "iam-role-eks-cluster" {
  name = "Role-for-eks-${var.project_name}-${var.env_name}"
  assume_role_policy = <<POLICY
{
 "Version": "2012-10-17",
 "Statement": [
   {
   "Effect": "Allow",
   "Principal": {
    "Service": "eks.amazonaws.com"
   },
   "Action": "sts:AssumeRole"
   }
  ]
 }
POLICY

  tags = {
    Name          = "Role-for-eks-${var.project_name}-${var.env_name}"
    Environment   = var.env_name
    Project_Name  = var.project_name
    Deployed_by   = "riyajkazi"
    Email         = "riyazikazi@gmail.com"
  }
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.iam-role-eks-cluster.name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.iam-role-eks-cluster.name
}

resource "aws_security_group" "eks_cluster_sg" {
  name        = "sg_for_EKSCluster_${var.project_name}_${var.env_name}"
  description = "Cluster communication with worker nodes"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name          = "sg_for_EKSCluster_${var.project_name}_${var.env_name}"
    Environment   = var.env_name
    Project_Name  = var.project_name
    Deployed_by   = "riyajkazi"
    Email         = "riyazikazi@gmail.com"
  }
}

resource "aws_eks_cluster" "eks_cluster" {
#module "eks" {
 # source = ""
  name     = "${var.project_name}-cluster"
  role_arn = aws_iam_role.iam-role-eks-cluster.arn
  version  = var.eks_version

  vpc_config {             # Configure EKS with vpc and network settings
   security_group_ids = [aws_security_group.eks_cluster_sg.id]
   subnet_ids         = [
                        data.terraform_remote_state.vpc.outputs.private_subnets[0],
                        data.terraform_remote_state.vpc.outputs.private_subnets[1],
     data.terraform_remote_state.vpc.outputs.private_subnets[2]
   ]
    }

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSServicePolicy,
   ]
  
  tags = {
    Name = "${var.project_name}-cluster"
    Environment = var.env_name
    Project_Name= var.project_name
    Deployed_by   = "riyajkazi"
    Email         = "riyazikazi@gmail.com"
  }


}

resource "null_resource" "connect-to-cluster" {
  provisioner "local-exec" {
    command = "aws --region ${var.aws_region} eks update-kubeconfig --name ${var.eks_cluster_name}"
  }

  depends_on = [
    aws_eks_cluster.eks_cluster
   ]
}

resource "time_sleep" "wait_60_seconds" {
  depends_on = [null_resource.connect-to-cluster]

  create_duration = "60s"
}


locals {
  map_users = [
    for map_user in var.map_users : {
      userarn  = map_user.userarn
      username = map_user.username
      groups   = try(map_user.groups, [])
    }
  ]
}

##################################################
# ConfigMap for AWS Auth Mapping
##################################################

resource "kubernetes_config_map" "this" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapUsers    = yamlencode(local.map_users)
  }

  depends_on = [
    time_sleep.wait_60_seconds
  ]
}

