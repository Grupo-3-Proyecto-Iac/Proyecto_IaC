# Proyecto_IaC
Proyecto de la asignatura *Infraestructura como Código (IaC)*.

Inicialmente, este proyecto implementaba únicamente un *bucket S3* con etiquetas de entorno.  
Actualmente, se amplió para incluir *funciones Lambda, **API Gateway* y una *tabla DynamoDB, conformando una infraestructura serverless completa desplegada en AWS mediante **Terraform*.

---

## 📝 Descripción del Problema
En universidades con matrícula flexible, muchos estudiantes irregulares (que arrastran/recursan cursos, convalidan, llevan créditos de distintos ciclos) construyen su horario con herramientas dispersas: malla curricular, NRC, hojas de cálculo y foros.  
Este proceso manual obliga a probar combinaciones a ciegas para evitar choques entre teoría–práctica–laboratorio, respetar prerrequisitos y acomodar restricciones personales.  
El proyecto busca sentar las bases de una infraestructura automatizada que facilite la gestión académica mediante servicios en la nube.

---

## 📊 Diagrama
<a align="center">
  <img src="https://drive.google.com/uc?export=view&id=1KeM7M8gX2uHxW3LgI9z4PE8VUlwxx1Hc" alt="Diagrama de Arquitectura AWS">
</a>

---

## 📦 Infraestructura Actual

El proyecto ahora implementa:

- *AWS S3*: Almacenamiento de datos con etiquetas por entorno.  
- *AWS Lambda*: Tres funciones principales (crearCurso, obtenerCurso, eliminarCurso).  
- *AWS API Gateway*: Exposición pública de las funciones Lambda como endpoints REST.  
- *AWS DynamoDB*: Tabla Cursos para persistir los datos de los cursos.  
- *AWS IAM Roles y Policies*: Roles de ejecución y permisos para Lambda y DynamoDB.

---

## 📂 Contenido del Proyecto
text
Proyecto_IaC/
├── README.md
├── .gitignore
└── Iac/
    ├── main.tf
    ├── providers.tf
    ├── variables.tf
    ├── terraform.tfvars
    └── lambdas/
        ├── crearCurso/
        │   └── index.js
        ├── obtenerCurso/
        │   └── index.js
        ├── eliminarCurso/
        │   └── index.js

---

## 📘 Descripción de Archivos

-   *main.tf*: Define los recursos principales de la infraestructura: S3, IAM Roles, Lambda Functions, DynamoDB y API Gateway.
-   *providers.tf*: Configura el proveedor de AWS y la versión del plugin hashicorp/aws.
-   *variables.tf*: Declara las variables usadas para parametrizar la infraestructura (región, entorno, etc.).
-   *terraform.tfvars*: Asigna valores concretos a las variables definidas en variables.tf.
-   *lambdas/*: Contiene el código fuente y los archivos .zip de las funciones Lambda.

---

## ⚙️ Requisitos Previos

- Tener instalado *Terraform* (versión 1.5.0 o superior).
- Contar con una cuenta activa en *AWS*.
- Configurar las credenciales de AWS CLI con aws configure.
- Tener *Node.js* instalado (para empaquetar las funciones Lambda).
- Acceso a internet para descargar el proveedor de AWS.

---

## 🚀 Uso

1.  *Clonar el repositorio:*
    bash
    git clone [https://github.com/Grupo-3-Proyecto-Iac/Proyecto_IaC.git](https://github.com/Grupo-3-Proyecto-Iac/Proyecto_IaC.git)
    cd Proyecto_IaC/Iac
    

2.  *Inicializar Terraform:*
    bash
    terraform init
    

3.  *Previsualizar los recursos que se crearán:*
    bash
    terraform plan
    

4.  *Aplicar los cambios (desplegar la infraestructura):*
    bash
    terraform apply -auto-approve
    

5.  *Destruir los recursos (evitar costos innecesarios):*
    bash
    terraform destroy -auto-approve
    

---

## 🧠 Notas Importantes

- *Generar archivos .zip:* Los archivos .zip de las Lambdas deben generarse manualmente antes del despliegue. Desde la carpeta Iac/, ejecuta:
  bash
  cd lambdas/crearCurso && zip -r ../crearCurso.zip . && cd ../..
  cd lambdas/obtenerCurso && zip -r ../obtenerCurso.zip . && cd ../..
  cd lambdas/eliminarCurso && zip -r ../eliminarCurso.zip . && cd ../..
  
- Este proyecto fue creado con fines académicos. Se recomienda ejecutar terraform destroy al finalizar las pruebas para evitar costos.
- Todos los recursos se crean bajo la región definida en terraform.tfvars (por defecto us-east-1).

---

## 👥 Autores
Gonzales Soto Alex
Sosa Macuyama Angelo
Tisnado Guevara Anthony
Vereau Tuesta Cristian
Mendoza Avila, Jorge Luis

Proyecto desarrollado por el *Grupo 3*.
- Asignatura: Infraestructura como Código (IaC) - Ingeniería de Sistemas e Inteligencia Artificial, UPAO.
- Año académico: 2025
