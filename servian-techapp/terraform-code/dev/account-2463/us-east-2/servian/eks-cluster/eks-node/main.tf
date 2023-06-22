data "terraform_remote_state" "eks-cluster" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "${var.account_name}-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/eks-cluster/eks-cluster/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "${var.account_name}-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "sg-nodes" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "${var.account_name}-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/security-group/sg-nodes/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_iam_role" "eks_nodes" {
  name = "eks-node-group-for-${var.project_name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = {
      Name = "eks-node-group-for-${var.project_name}"
      Environment   = var.env_name
      Project_Name  = var.project_name
      Deployed_by   = "riyajkazi"
      Email         = "riyazikazi@gmail.com"
    }
}

resource "aws_iam_policy" "asg_policy_for_eks_workernode" {
  name        = "asg_policy_for_eks_workernode"
  path        = "/"
  description = "autoscalar"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplateVersions"
            ],
            "Resource": "*"
        }
    ]
})

  tags = {
    Name = "asg_policy_for_eks_workernode"
    Environment   = var.env_name
    Project_Name  = var.project_name
    Deployed_by   = "riyajkazi"
    Email         = "riyazikazi@gmail.com"
  }
}

resource "aws_iam_role_policy_attachment" "asg_policy_for_eks_workernode" {
  policy_arn = aws_iam_policy.asg_policy_for_eks_workernode.arn
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "SSMPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_eks_node_group" "eks-node" {
  cluster_name    =  data.terraform_remote_state.eks-cluster.outputs.cluster_name
  node_group_name = "${var.project_name}-node-group"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  disk_size = var.eks_node_disk_size
  instance_types = [var.eks_node_instance_types]

  tags = {
    "kubernetes.io/cluster/${data.terraform_remote_state.eks-cluster.outputs.cluster_name}" = "shared"
    "k8s.io/cluster-autoscaler/${data.terraform_remote_state.eks-cluster.outputs.cluster_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled" = "TRUE"
    "Name"          = "${var.project_name}-node-group"
    "Environment"   = var.env_name
    "Project_Name"  = var.project_name
    "Deployed_by"   = "riyajkazi"
    "Email"         = "riyazikazi@gmail.com"
  }
  subnet_ids      = [data.terraform_remote_state.vpc.outputs.private_subnets[0],
                        data.terraform_remote_state.vpc.outputs.private_subnets[1],
     data.terraform_remote_state.vpc.outputs.private_subnets[2]]



  scaling_config {
    desired_size = var.eks_node_desired_size
    max_size     = var.eks_node_max_size
    min_size     = var.eks_node_min_size
  }
  remote_access {
      ec2_ssh_key = var.eks_node_key_pair
      source_security_group_ids = [data.terraform_remote_state.sg-nodes.outputs.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}