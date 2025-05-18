resource "aws_eks_node_group" "workers" {
  cluster_name    = var.eks_cluster
  node_group_name = "db-workers"
  node_role_arn   = aws_iam_role.workers.arn
  subnet_ids      = aws_subnet.private.*.id
  
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  ami_type     = "AL2_x86_64"
  disk_size    = 20
  instance_types = ["t3.medium"]
  
  labels = {
    Environment = "db"
  }

  depends_on = [
    aws_iam_role_policy_attachment.workers-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.workers-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.workers-AmazonEC2ContainerRegistryReadOnly
  ]
}

resource "aws_iam_role" "workers" {
  name = "eks-db-workers-${var.eks_cluster}"

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

resource "aws_iam_role_policy_attachment" "workers-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.workers.name
}

resource "aws_iam_role_policy_attachment" "workers-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.workers.name
}

resource "aws_iam_role_policy_attachment" "workers-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.workers.name
}
