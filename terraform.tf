terraform {
  required_version = "0.12.26"
  backend "s3" {
    bucket = "your-tfstate-bucket-name"
    key    = "us-east-1/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "template" {
  version = "2.1.2"
}
