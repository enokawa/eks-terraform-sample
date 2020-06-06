resource "aws_security_group" "alb" {
  name        = "${var.stage}-alb-sg"
  description = "${var.stage}-alb-sg"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name        = "${var.stage}-alb-sg"
    Environment = var.stage
  }
}

resource "aws_security_group_rule" "alb_ingress_80" {
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_ingress_443" {
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_egress_all" {
  security_group_id = aws_security_group.alb.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group" "eks_cluster" {
  name        = "${var.stage}-eks-cluster-sg"
  description = "${var.stage}-eks-cluster-sg"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name        = "${var.stage}-eks-cluster-sg"
    Environment = var.stage
  }
}

resource "aws_security_group_rule" "eks_cluster_sg_ingress_443" {
  security_group_id = aws_security_group.eks_cluster.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"

  source_security_group_id = aws_security_group.eks_worker_node.id
}

resource "aws_security_group_rule" "eks_cluster_sg_egress_1025_65535" {
  security_group_id = aws_security_group.eks_cluster.id
  type              = "egress"
  from_port         = 1025
  to_port           = 65535
  protocol          = "-1"

  source_security_group_id = aws_security_group.eks_worker_node.id
}


resource "aws_security_group" "eks_worker_node" {
  name        = "${var.stage}-eks-worker-node-sg"
  description = "${var.stage}-eks-worker-node-sg"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name        = "${var.stage}-eks-worker-node-sg"
    Environment = var.stage
  }
}

resource "aws_security_group_rule" "eks_worker_node_ingress_self" {
  security_group_id = aws_security_group.eks_worker_node.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
}

resource "aws_security_group_rule" "eks_worker_node_ingress_443" {
  security_group_id = aws_security_group.eks_worker_node.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"

  source_security_group_id = aws_security_group.eks_cluster.id
}

resource "aws_security_group_rule" "eks_worker_node_ingress_1025_65535" {
  security_group_id = aws_security_group.eks_worker_node.id
  type              = "ingress"
  from_port         = 1025
  to_port           = 65535
  protocol          = "tcp"

  source_security_group_id = aws_security_group.eks_cluster.id
}

resource "aws_security_group_rule" "eks_worker_node_ingress_all" {
  security_group_id = aws_security_group.eks_worker_node.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"

  source_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "eks_worker_node_egress_all" {
  security_group_id = aws_security_group.eks_worker_node.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
