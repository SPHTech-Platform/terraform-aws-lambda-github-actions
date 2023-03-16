data "archive_file" "dummy" {
  output_path = "${path.module}/dummy.zip"
  type        = "zip"
  source {
    content  = "dummy content"
    filename = "dummy.txt"
  }
}

module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 4.10.1"

  function_name              = var.function_name
  description                = var.function_description
  role_name                  = "${var.function_name}-role"
  handler                    = var.function_index_handler
  runtime                    = var.lambda_runtime
  create_package             = false
  environment_variables      = var.lambda_environment_variables
  allowed_triggers           = var.allowed_triggers
  create_lambda_function_url = true
  authorization_type         = var.authorization_type
  cors                       = var.cors
  attach_policy_jsons        = true
  ignore_source_code_hash    = true
  # dummy package, package is delegated to CI pipeline
  local_existing_package = data.archive_file.dummy.output_path
  policy_jsons           = var.addition_lambda_policy
}
