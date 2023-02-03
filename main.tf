terraform {
  required_version = ">= 1.1.0"

  required_providers {
    aws = {
      version = ">= 3.50.0"
      source  = "hashicorp/aws"
    }
    azurerm = {
      version = "2.70.0"
      source  = "hashicorp/azurerm"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      owner       = "cloudlab"
      manager     = "terraform"
      environment = "Dev"
    }
  }
}