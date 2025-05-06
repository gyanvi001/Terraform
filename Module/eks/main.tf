provider "aws" {
    region = "us-west-2"
}

# Create the IAM role for the EKS cluster - control plane
resource "aws_iam_role" "cluster" {
    name = "${var.cluster_name}-cluster-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "eks.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            }
        ]
    })
}

# Attach the EKS Cluster policy to the IAM role
resource "aws_iam_role_policy_attachment" "cluster_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role       = aws_iam_role.cluster.name  
}

# Create the EKS Cluster
resource "aws_eks_cluster" "main_cluster" {  
    name     = var.cluster_name
    version  = var.cluster_version
    role_arn = aws_iam_role.cluster.arn

    vpc_config {
        subnet_ids = var.subnet_ids
    }

    depends_on = [ 
        aws_iam_role_policy_attachment.cluster_policy
    ]
}

# Create IAM role for EKS worker nodes
resource "aws_iam_role" "node" {
    name = "${var.cluster_name}-node-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            }
        ]
    })
}

# Attach required policies to the worker node role
resource "aws_iam_role_policy_attachment" "node_policy" {
    for_each = toset([
        "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    ])
    policy_arn = each.value
    role       = aws_iam_role.node.name
}

# Create the EKS EC2 Instance node group
resource "aws_eks_node_group" "node_group" {
    for_each       = var.node_groups
    cluster_name   = aws_eks_cluster.main_cluster.name  # ✅ Fixed hyphen issue
    node_group_name = each.key
    node_role_arn  = aws_iam_role.node.arn
    subnet_ids     = var.subnet_ids

    instance_types = each.value.instance_types
    capacity_type  = each.value.capacity_type
    

    # Scaling configuration
    scaling_config {
        desired_size = each.value.scaling_config.desired_size
        max_size     = each.value.scaling_config.max_size
        min_size     = each.value.scaling_config.min_size
    }

    # Tags for automatic EKS discovery
    tags = {
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }

    depends_on = [ 
        aws_iam_role_policy_attachment.node_policy
    ]
}


