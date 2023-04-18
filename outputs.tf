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

# For Lambda Edge and Cloudfront Integration

#For Lambda@Edge Association with cloudfront
output "qualified_arn" {
  description = "The qualified arn of the lambda function to be associated with Cloudfront as a Lambda@Edge function"
  value = module.lambda.lambda_function_qualified_arn
}

#For using lambda as origin for cloudfront
output "function_url" {
  description = "The function url of lambda function to be able to be set as cloudfront origin"
  value = module.lambda.lambda_function_url
}

output "function_url_id" {
  description = "The function url ID of lambda function to be able to be set as cloudfront origin"
  value = module.lambda.lambda_function_url_id
}

#To associate lambdas with api gateway integration
output "invoke_arn" {
  description = "The invoke arn of lambda function for APIGW integration"
  value = module.lambda.lambda_function_invoke_arn
}
