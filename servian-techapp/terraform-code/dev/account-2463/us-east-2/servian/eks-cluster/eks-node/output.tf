output "node_group_name" {
  description = "node_name"
  value       = aws_eks_node_group.eks-node.node_group_name
}
output "node_group_arn" {
  description = "node_name"
  value       = aws_eks_node_group.eks-node.arn
}

output "node_group_id" {
  description = "node group id"
  value       = aws_eks_node_group.eks-node.id
}

output "remote_access_security_group_ids" {
  description = "node group id"
  value       = aws_eks_node_group.eks-node.remote_access[0].source_security_group_ids
}
