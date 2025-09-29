terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.14.1"
    }
  }
}

# Configurar el proveedor de AWS
provider "aws" {
  region  = var.region
  profile = var.profile
}