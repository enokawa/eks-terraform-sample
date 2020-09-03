resource "aws_iam_role" "eks_cluster" {
  name = "${var.stage}-eks-cluster-role"

  assume_role_policy = <<EOF
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
EOF
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy_attach" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "eks_worker_node" {
  name = "${var.stage}-eks-worker-node-role"

  assume_role_policy = <<EOF
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
EOF
}

resource "aws_iam_instance_profile" "eks_worker_node" {
  name = "${var.stage}-eks-worker-node-profile"
  role = aws_iam_role.eks_worker_node.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy_attach" {
  role       = aws_iam_role.eks_worker_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy_attach" {
  role       = aws_iam_role.eks_worker_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly_attach" {
  role       = aws_iam_role.eks_worker_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

data "external" "thumbprint" {
  program = ["sh", "shell/thumbprint.sh"]
}


resource "aws_iam_openid_connect_provider" "app" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.external.thumbprint.result.thumbprint]
  url             = aws_eks_cluster.app.identity[0].oidc[0].issuer
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "alb_ingress_controller_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.app.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:alb-ingress-controller"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.app.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "alb_ingress_controller" {
  name               = "${var.stage}-alb-ingress-controller-role"
  assume_role_policy = data.aws_iam_policy_document.alb_ingress_controller_role_policy.json
}

resource "aws_iam_policy" "alb_ingress_controller" {
  name        = "${var.stage}-alb-ingress-controller-policy"
  path        = "/"

  policy = file("policy/alb-ingress-controller.json")
}

resource "aws_iam_role_policy_attachment" "alb_ingress_controller_attach" {
  role       = aws_iam_role.alb_ingress_controller.name
  policy_arn = aws_iam_policy.alb_ingress_controller.arn
}
