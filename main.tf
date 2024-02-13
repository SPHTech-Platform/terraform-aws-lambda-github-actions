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
  version = "~> 7.2.1"

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
  attach_tracing_policy          = var.attach_tracing_policy
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

  create_role              = var.create_lambda_role
  role_name                = var.role_name
  attach_policy_jsons      = var.attach_policy_jsons
  attach_policy_json       = var.attach_policy_json
  attach_policy_statements = var.attach_policy_statements
  attach_policies          = var.attach_policies
  attach_network_policy    = var.attach_network_policy

  ignore_source_code_hash = true

  # dummy package, package is delegated to CI pipeline
  local_existing_package   = data.archive_file.dummy.output_path
  recreate_missing_package = var.recreate_missing_package
  source_path              = var.source_path
  policies                 = var.managed_policy_arns
  policy_jsons             = var.policy_jsons
  policy_json              = var.policy_json
  policy_statements        = var.policy_statements
  number_of_policy_jsons   = var.number_of_policy_jsons
  number_of_policies       = var.number_of_managed_policies

  use_existing_cloudwatch_log_group = !var.create_lambda_cloudwatch_log_group
  cloudwatch_logs_retention_in_days = var.cloudwatch_logs_retention_in_days

  logging_application_log_level = var.logging_info.application_log_level
  logging_log_format            = var.logging_info.log_format
  logging_log_group             = var.logging_info.log_group
  logging_system_log_level      = var.logging_info.system_log_level
}
