# Crear un bucket de S3 en AWS
resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

# --- IAM Role para Lambda ---
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { 
        Service = "lambda.amazonaws.com" 
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_access" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

# --- DynamoDB ---
resource "aws_dynamodb_table" "cursos" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

# --- Lambda crearCurso ---
resource "aws_lambda_function" "crear_curso" {
  function_name = "crearCurso"
  runtime       = var.lambda_runtime
  handler       = var.lambda_handler
  filename      = "${path.module}/lambdas/crearCurso.zip"
  role          = aws_iam_role.lambda_exec_role.arn

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.cursos.name
    }
  }
}

# --- Lambda obtenerCurso ---
resource "aws_lambda_function" "obtener_curso" {
  function_name = "obtenerCurso"
  runtime       = var.lambda_runtime
  handler       = var.lambda_handler
  filename      = "${path.module}/lambdas/obtenerCurso.zip"
  role          = aws_iam_role.lambda_exec_role.arn

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.cursos.name
    }
  }
}

# --- Lambda eliminarCurso ---
resource "aws_lambda_function" "eliminar_curso" {
  function_name = "eliminarCurso"
  runtime       = var.lambda_runtime
  handler       = var.lambda_handler
  filename      = "${path.module}/lambdas/eliminarCurso.zip"
  role          = aws_iam_role.lambda_exec_role.arn

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.cursos.name
    }
  }
}

# --- API Gateway ---
resource "aws_apigatewayv2_api" "lms_api" {
  name          = "LMS-API"
  protocol_type = "HTTP"
}

# Integraciones
resource "aws_apigatewayv2_integration" "crear_curso_integration" {
  api_id                 = aws_apigatewayv2_api.lms_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.crear_curso.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "obtener_curso_integration" {
  api_id                 = aws_apigatewayv2_api.lms_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.obtener_curso.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "eliminar_curso_integration" {
  api_id                 = aws_apigatewayv2_api.lms_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.eliminar_curso.invoke_arn
  payload_format_version = "2.0"
}

# Rutas
resource "aws_apigatewayv2_route" "post_curso" {
  api_id    = aws_apigatewayv2_api.lms_api.id
  route_key = "POST /curso"
  target    = "integrations/${aws_apigatewayv2_integration.crear_curso_integration.id}"
}

resource "aws_apigatewayv2_route" "get_curso" {
  api_id    = aws_apigatewayv2_api.lms_api.id
  route_key = "GET /curso"
  target    = "integrations/${aws_apigatewayv2_integration.obtener_curso_integration.id}"
}

resource "aws_apigatewayv2_route" "delete_curso" {
  api_id    = aws_apigatewayv2_api.lms_api.id
  route_key = "DELETE /curso/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.eliminar_curso_integration.id}"
}

# Permisos Lambda → API Gateway
resource "aws_lambda_permission" "allow_api_gateway_crear" {
  statement_id  = "AllowAPIGatewayInvokeCrear"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.crear_curso.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lms_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_obtener" {
  statement_id  = "AllowAPIGatewayInvokeObtener"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.obtener_curso.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lms_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_eliminar" {
  statement_id  = "AllowAPIGatewayInvokeEliminar"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.eliminar_curso.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lms_api.execution_arn}/*/*"
}

# Stage
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.lms_api.id
  name        = "$default"
  auto_deploy = true
}

# Output
output "api_url" {
  description = "URL base del API Gateway"
  value       = aws_apigatewayv2_api.lms_api.api_endpoint
}