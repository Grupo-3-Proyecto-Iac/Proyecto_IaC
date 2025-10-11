terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.16.0"
    }
  }
}

# Configurar el proveedor de AWS
provider "aws" {
  region  = var.region
  profile = var.profile
}

