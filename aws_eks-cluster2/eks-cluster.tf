# EKS cluster and role

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks_cluster_role"
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

resource "aws_iam_role_policy_attachment" "eks_cluster_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_eks_cluster" "pumej_cluster" {
  name     = "pumejeks_cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.26"

  vpc_config {
    subnet_ids = [
      aws_subnet.eks_priv_sub_one.id,
      aws_subnet.eks_priv_sub_two.id,
      aws_subnet.eks_pub_sub_one.id,
      aws_subnet.eks_pub_sub_two.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_role_attachment]
}
