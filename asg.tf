resource "aws_autoscaling_group" "eks_worker_node_asg" {
  name                      = "${var.stage}-eks-worker-node-asg"
  max_size                  = 3
  min_size                  = 3
  health_check_grace_period = 60
  default_cooldown          = 300
  termination_policies = [
    "OldestInstance",
    "OldestLaunchTemplate"
  ]

  vpc_zone_identifier = [
    aws_subnet.app_a.id,
    aws_subnet.app_b.id,
    aws_subnet.app_c.id
  ]

  launch_template {
    id      = aws_launch_template.eks_worker_node_template.id
    version = "$Latest"
  }

  tags = [
    {
      key                 = "Name"
      value               = "${var.stage}-eks-worker-node"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = var.stage
      propagate_at_launch = true
    },
    {
      key                 = "kubernetes.io/cluster/${var.stage}-app-cluster"
      value               = "owned"
      propagate_at_launch = true
    }
  ]
}
