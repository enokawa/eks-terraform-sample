# eks-terraform-sample

Terraform sample code to create Amazon EKS.

## Prerequisite

- [tfenv](https://github.com/tfutils/tfenv)
- [AWS CLI](https://aws.amazon.com/cli/)

## Usage

Set environment variable `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_DEFAULT_REGION`.

```shell
$ direnv edit . # direnv is not required
export AWS_ACCESS_KEY_ID=AKIAXXXXXXXXXXXXXXXXXX
export AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXX
export AWS_REGION=ap-northeast-1
```

Modify S3 bucket settings for remote state on `terraform.tf`.

```hcl
terraform {
  required_version = "0.12.26"
  backend "s3" {
    bucket = "my-awesome-app-tfstate" # 
    key    = "us-east-1/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
```

Modify your source ip addresses for [cluster endpoint access control](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html) on `variables.tf`.

```hcl
variable "eks_public_access_cidrs" {
  type    = list
  default = ["54.XX.XX.XX/32"] # Enter your source ip
}
```

Install Terraform binary use tfenv and execute `terraform init`.

```shell
$ tfenv install
$ terraform init
```

## Apply

```shell
$ terraform plan
$ terraform apply
```

## Update kubeconfig

```shell
$ aws eks update-kubeconfig --name dev-app
```

## Apply aws-auth configMap

See document bellow:

[Managing users or IAM roles for your cluster - Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html)

## Destroy

```shell
$ terraform destroy
```
