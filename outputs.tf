output "lambda_function_arn" {
  description = "Lambda Function ARN"
  value       = module.lambda.lambda_function_arn
}

output "lambda_function_name" {
  description = "Lambda Function Name"
  value       = module.lambda.lambda_function_name
}

# Cloudwatch Log Group
output "lambda_cloudwatch_log_group_arn" {
  description = "Lambda Cloudwatch Log group"
  value       = module.lambda.lambda_cloudwatch_log_group_arn
}

output "lambda_cloudwatch_log_group_name" {
  description = "Lambda Cloudwatch Log group"
  value       = module.lambda.lambda_cloudwatch_log_group_name
}

# IAM Role
output "lambda_role_arn" {
  description = "ARN of the IAM role created for the Lambda Function"
  value       = module.lambda.lambda_role_arn
}

output "lambda_role_name" {
  description = "The name of the IAM role created for the Lambda Function"
  value       = module.lambda.lambda_role_name
}

output "lambda_role_unique_id" {
  description = "The unique id of the IAM role created for the Lambda Function"
  value       = module.lambda.lambda_role_unique_id
}

# Github Actions
output "github_actions_role_arn" {
  description = "Role ARN used by the Github Actions"
  value       = module.github_actions_repo.role
}
