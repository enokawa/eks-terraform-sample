variable "stage" {
  type    = string
  default = "dev"
}

variable "worker_node_instance_type" {
  type    = string
  default = "t3.small"
}

variable "eks_public_access_cidrs" {
  type    = list
  default = ["54.XX.XX.XX/32"] # Enter your source ip
}
