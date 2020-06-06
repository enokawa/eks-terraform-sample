data "template_file" "user_data" {
  template = file("shell/bootstrap.tpl")
  vars = {
    eks_cluster_name = aws_eks_cluster.app.name
  }
}

data "aws_ssm_parameter" "eks_optimized_ami_id" {
  name = "/aws/service/eks/optimized-ami/1.16/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_template" "eks_worker_node_template" {
  name                   = "${var.stage}-eks-worker-node-template"
  image_id               = data.aws_ssm_parameter.eks_optimized_ami_id.value
  instance_type          = var.worker_node_instance_type
  ebs_optimized          = true
  vpc_security_group_ids = [aws_security_group.eks_worker_node.id]
  user_data              = base64encode(data.template_file.user_data.rendered)

  iam_instance_profile {
    name = aws_iam_instance_profile.eks_worker_node.name
  }
}
