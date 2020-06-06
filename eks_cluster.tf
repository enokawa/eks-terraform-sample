resource "aws_eks_cluster" "app" {
  name     = "${var.stage}-app"
  role_arn = aws_iam_role.eks_cluster.arn
  version  = "1.16"

  vpc_config {
    endpoint_public_access  = true
    endpoint_private_access = true
    public_access_cidrs     = var.eks_public_access_cidrs

    security_group_ids = [aws_security_group.eks_cluster.id]
    subnet_ids = [
      aws_subnet.public_a.id,
      aws_subnet.public_b.id,
      aws_subnet.public_c.id,
      aws_subnet.app_a.id,
      aws_subnet.app_b.id,
      aws_subnet.app_b.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy_attach
  ]

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
}
