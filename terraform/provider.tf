terraform {
    backend "s3" {
        bucket         =  "bluegreen-bucket-20260227"
        key            = "bluegreen/terraform.tfstate"
        region         = "us-east-1"
        encrypt        = true
    }
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "6.16.0"
        }
    }
}

provider "aws" {
    region = var.aws_region
}
