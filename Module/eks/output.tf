output "cluster_endpoint" {
    description = "The endpoint for the EKS Kubernetes API"
    value = aws_eks_cluster.main_cluster.endpoint
  
}

output "cluster_name" {
    description = "value of the EKS cluster name"
    value = aws_eks_cluster.main_cluster.name
  
}