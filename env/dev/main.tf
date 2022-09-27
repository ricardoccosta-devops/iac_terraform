terraform {
  cloud {
    organization = "digio"
    workspaces {
      name = "wl-iaac-of-out-serv-channels-dev"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.28.0"
    }
  }
  required_version = ">= 1.1.0"
}