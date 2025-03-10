// configure the MongoDB Atlas Provider 
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

// setting up s3 bucket for a remote backend
terraform {
  backend "s3" {
    bucket = "terraform-ecs-nodejs"
    key    = "statefile2/terraform.tfstate"
    region = "us-east-1"
  }
}