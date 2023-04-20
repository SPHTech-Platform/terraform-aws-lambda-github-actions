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
  version = "~> 4.14.0"

  function_name = var.function_name
  description   = var.description
  lambda_role   = var.lambda_role

  create_package = false

  lambda_at_edge = var.lambda_at_edge
  handler        = var.handler
  runtime        = var.runtime

  architectures                  = var.architectures
  code_signing_config_arn        = var.code_signing_config_arn
  layers                         = var.layers
  kms_key_arn                    = var.kms_key_arn
  memory_size                    = var.memory_size
  ephemeral_storage_size         = var.ephemeral_storage_size
  environment_variables          = var.environment_variables
  publish                        = var.publish
  reserved_concurrent_executions = var.reserved_concurrent_executions
  timeout                        = var.timeout
  dead_letter_target_arn         = var.dead_letter_target_arn
  tracing_mode                   = var.tracing_mode
  vpc_subnet_ids                 = var.vpc_subnet_ids
  vpc_security_group_ids         = var.vpc_security_group_ids
  package_type                   = var.package_type
  image_uri                      = var.image_uri
  image_config_entry_point       = var.image_config_entry_point
  image_config_command           = var.image_config_command
  image_config_working_directory = var.image_config_working_directory
  snap_start                     = var.snap_start

  create_current_version_allowed_triggers = var.create_current_version_allowed_triggers
  allowed_triggers                        = var.allowed_triggers

  create_lambda_function_url                   = var.create_lambda_function_url
  create_unqualified_alias_lambda_function_url = var.create_unqualified_alias_lambda_function_url
  authorization_type                           = var.authorization_type
  cors                                         = var.cors

  role_name             = var.role_name
  attach_policy_jsons   = var.attach_policy_jsons
  attach_network_policy = var.attach_network_policy

  ignore_source_code_hash = true

  # dummy package, package is delegated to CI pipeline
  local_existing_package = data.archive_file.dummy.output_path
  policy_jsons           = var.policy_jsons
  policy_statements      = var.policy_statements
  number_of_policy_jsons  = var.number_of_policy_jsons

}
