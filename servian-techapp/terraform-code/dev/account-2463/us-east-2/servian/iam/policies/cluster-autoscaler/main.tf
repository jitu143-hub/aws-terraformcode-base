data "aws_iam_policy_document" "cluster_autoscaler_asg_policy" {
  statement {
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions"
    ]
    resources = [
      "*",
    ]
  }
}

module "iam_policy" {
  source = "/mnt/c/personal/MT/servian-techapp/iac-module-aws/iam//iam-policy"

  name        = "cluster-autoscaler-asg-policy"
  path        = "/"
  description = "Policy to allow cluster-autoscaler to access asg to autoscale eks cluster"

  policy = data.aws_iam_policy_document.cluster_autoscaler_asg_policy.json
}