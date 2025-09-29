variable "region" {
  description = "La región de AWS en la que se crearán los recursos"
  type        = string
}

variable "profile" {
  description = "El perfil de AWS CLI que se utilizará"
  type        = string
}

variable "bucket_name" {
  description = "El nombre del bucket S3"
  type        = string
}

variable "environment" {
  description = "El entorno para los recursos"
  type        = string
}
