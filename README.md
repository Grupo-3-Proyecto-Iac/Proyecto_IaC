# Proyecto_IaC
Proyecto de la asignatura Infraestructura como código

Actualmente solo se implementa un **bucket S3** con etiquetas para identificarlo por entorno.

---
## 📝Descripción del Problema
En universidades con matrícula flexible, muchos estudiantes irregulares (que arrastran/recursan cursos, convalidan, llevan créditos de distintos ciclos) construyen su horario con herramientas dispersas: malla curricular, NRC, hojas de cálculo y foro. Este proceso manual obliga a probar combinaciones a ciegas para evitar choques entre teoría–práctica–laboratorio, respetar prerrequisitos y acomodar restricciones personales.

---
## 📊 Diagrama
<a align="center">
  <img src="https://drive.google.com/uc?export=view&id=1KeM7M8gX2uHxW3LgI9z4PE8VUlwxx1Hc" alt="Texto alternativo para la imagen">
</a>


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

mi primer commit
