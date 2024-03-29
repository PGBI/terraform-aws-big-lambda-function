output "arn" {
  description = "ARN of the lambda function."
  value       = aws_lambda_function.main.arn
}

output "invoke_arn" {
  description = "The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's uri."
  value       = aws_lambda_function.main.invoke_arn
}

output "name" {
  description = "Name of the lambda function."
  value       = aws_lambda_function.main.function_name
}

output "role_arn" {
  description = "ARN of the role assumed by the lambda funtion."
  value       = module.role.arn
}

output "role_id" {
  description = "Name of the role assumed by the lambda funtion."
  value       = module.role.id
}

output "role_name" {
  description = "Name of the role assumed by the lambda funtion."
  value       = module.role.name
}

output "src_bucket_arn" {
  description = "ARN of the S3 bucket in which the deployment package is stored."
  value       = module.source_store.arn
}

output "src_bucket_name" {
  description = "Name of the S3 bucket in which the deployment package is stored."
  value       = module.source_store.name
}
