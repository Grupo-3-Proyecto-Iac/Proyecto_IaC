# Proyecto_IaC
Proyecto de la asignatura Infraestructura como código

Actualmente solo se implementa un **bucket S3** con etiquetas para identificarlo por entorno.

---

## 📂 Contenido del Proyecto
```text
Proyecto_IaC/
├── README.md
├── .gitignore
└── Iac/
    ├── main.tf
    ├── variables.tf
    ├── version.tf
    ├── terraform.tfvars
```
    
- **main.tf**  
  Contiene la definición del recurso `aws_s3_bucket` que crea un bucket S3 en AWS.

- **variables.tf**  
  Define las variables necesarias para parametrizar la configuración.

- **terraform.tfvars**  
  Asigna valores concretos a las variables declaradas en `variables.tf`.

---

## ⚙️ Requisitos Previos

- Tener instalado **Terraform**.  
- Tener configuradas tus credenciales de AWS CLI utilizando `aws configure`.

---

## 🚀 Uso

1. Clona este repositorio.
2. Accede a la carpeta `./Iac` e inicializa Terraform usando `terraform init`.
3. Ejecutando `terraform plan` se podrá apreciar **los cambios que se aplicarán en la infraestructura antes de crearlos**.

