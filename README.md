# Github Actions Lambda Deployer Terraform module

Terraform module for creating the lambda and the github actions IAM Role deployer to deploy the lambda code

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.27 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | ~> 1.3 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.27 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda"></a> [lambda](#module\_lambda) | terraform-aws-modules/lambda/aws | ~> 4.14.0 |
| <a name="module_lamda_gha"></a> [lamda\_gha](#module\_lamda\_gha) | philips-labs/github-oidc/aws | ~> 0.7.0 |
| <a name="module_oidc_provider"></a> [oidc\_provider](#module\_oidc\_provider) | philips-labs/github-oidc/aws//modules/provider | ~> 0.7.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role_policy.update_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [archive_file.dummy](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |
| [aws_iam_policy_document.update_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_triggers"></a> [allowed\_triggers](#input\_allowed\_triggers) | Map of allowed triggers to create Lambda permissions | `map(any)` | `{}` | no |
| <a name="input_architectures"></a> [architectures](#input\_architectures) | Instruction set architecture for your Lambda function. Valid values are ["x86\_64"] and ["arm64"]. | `list(string)` | `null` | no |
| <a name="input_attach_network_policy"></a> [attach\_network\_policy](#input\_attach\_network\_policy) | Flag to attach network policy to use VPC subnet and security group | `bool` | `false` | no |
| <a name="input_attach_policy_jsons"></a> [attach\_policy\_jsons](#input\_attach\_policy\_jsons) | Controls whether policy\_jsons should be added to IAM role for Lambda Function | `bool` | `false` | no |
| <a name="input_authorization_type"></a> [authorization\_type](#input\_authorization\_type) | The type of authentication that the Lambda Function URL uses. Set to 'AWS\_IAM' to restrict access to authenticated IAM users only. Set to 'NONE' to bypass IAM authentication and create a public endpoint. | `string` | `"NONE"` | no |
| <a name="input_code_signing_config_arn"></a> [code\_signing\_config\_arn](#input\_code\_signing\_config\_arn) | Amazon Resource Name (ARN) for a Code Signing Configuration | `string` | `null` | no |
| <a name="input_cors"></a> [cors](#input\_cors) | CORS settings to be used by the Lambda Function URL | `any` | `{}` | no |
| <a name="input_create_current_version_allowed_triggers"></a> [create\_current\_version\_allowed\_triggers](#input\_create\_current\_version\_allowed\_triggers) | Whether to allow triggers on current version of Lambda Function (this will revoke permissions from previous version because Terraform manages only current resources) | `bool` | `true` | no |
| <a name="input_create_github_actions_oidc_provider"></a> [create\_github\_actions\_oidc\_provider](#input\_create\_github\_actions\_oidc\_provider) | Controls Whether to create openid connect provider. | `bool` | `false` | no |
| <a name="input_create_github_actions_role"></a> [create\_github\_actions\_role](#input\_create\_github\_actions\_role) | Controls whether to create AWS OIDC integration GitHub Actions | `bool` | `true` | no |
| <a name="input_create_lambda_function_url"></a> [create\_lambda\_function\_url](#input\_create\_lambda\_function\_url) | Controls whether the Lambda Function URL resource should be created | `bool` | `false` | no |
| <a name="input_create_unqualified_alias_lambda_function_url"></a> [create\_unqualified\_alias\_lambda\_function\_url](#input\_create\_unqualified\_alias\_lambda\_function\_url) | Whether to use unqualified alias pointing to $LATEST version in Lambda Function URL | `bool` | `true` | no |
| <a name="input_dead_letter_target_arn"></a> [dead\_letter\_target\_arn](#input\_dead\_letter\_target\_arn) | The ARN of an SNS topic or SQS queue to notify when an invocation fails. | `string` | `null` | no |
| <a name="input_default_conditions"></a> [default\_conditions](#input\_default\_conditions) | (Optional) Default condtions to apply, at least one of the following is madatory: 'allow\_main', 'allow\_environment', 'deny\_pull\_request' and 'allow\_all'. | `list(string)` | <pre>[<br>  "allow_main",<br>  "allow_environment"<br>]</pre> | no |
| <a name="input_description"></a> [description](#input\_description) | Lambda Function Description | `string` | `""` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | A map that defines environment variables for the Lambda Function. | `map(string)` | `{}` | no |
| <a name="input_ephemeral_storage_size"></a> [ephemeral\_storage\_size](#input\_ephemeral\_storage\_size) | Amount of ephemeral storage (/tmp) in MB your Lambda Function can use at runtime. Valid value between 512 MB to 10,240 MB (10 GB). | `number` | `512` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Lambda Function Name | `string` | n/a | yes |
| <a name="input_function_prefix"></a> [function\_prefix](#input\_function\_prefix) | Prefix for the IAM role for lambda functions | `string` | `""` | no |
| <a name="input_github_repo"></a> [github\_repo](#input\_github\_repo) | GitHub repo to grant access to assume a role via OIDC. | <pre>object({<br>    repo         = string<br>    branches     = optional(list(string), [])<br>    environments = optional(list(string), [])<br>    bucket_name  = string<br><br>    # Custom Role name. It will autocreate based on repo if not provided<br>    role_name = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_handler"></a> [handler](#input\_handler) | Lambda Function Index Handler | `string` | `"index.handler"` | no |
| <a name="input_image_config_command"></a> [image\_config\_command](#input\_image\_config\_command) | The CMD for the docker image | `list(string)` | `[]` | no |
| <a name="input_image_config_entry_point"></a> [image\_config\_entry\_point](#input\_image\_config\_entry\_point) | The ENTRYPOINT for the docker image | `list(string)` | `[]` | no |
| <a name="input_image_config_working_directory"></a> [image\_config\_working\_directory](#input\_image\_config\_working\_directory) | The working directory for the docker image | `string` | `null` | no |
| <a name="input_image_uri"></a> [image\_uri](#input\_image\_uri) | The ECR image URI containing the function's deployment package. | `string` | `null` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of KMS key to use by your Lambda Function | `string` | `null` | no |
| <a name="input_lambda_at_edge"></a> [lambda\_at\_edge](#input\_lambda\_at\_edge) | Set this to true if using Lambda@Edge, to enable publishing, limit the timeout, and allow edgelambda.amazonaws.com to invoke the function | `bool` | `false` | no |
| <a name="input_lambda_role"></a> [lambda\_role](#input\_lambda\_role) | IAM role ARN attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to. See Lambda Permission Model for more details. | `string` | `""` | no |
| <a name="input_layers"></a> [layers](#input\_layers) | List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function. | `list(string)` | `null` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory in MB your Lambda Function can use at runtime. Valid value between 128 MB to 10,240 MB (10 GB), in 64 MB increments. | `number` | `128` | no |
| <a name="input_package_type"></a> [package\_type](#input\_package\_type) | The Lambda deployment package type. Valid options: Zip or Image | `string` | `"Zip"` | no |
| <a name="input_policy_jsons"></a> [policy\_jsons](#input\_policy\_jsons) | List of additional policies for the lambda execution | `list(string)` | `[]` | no |
| <a name="input_policy_statements"></a> [policy\_statements](#input\_policy\_statements) | Additional Inline Lambda Policy Statements | `any` | `{}` | no |
| <a name="input_publish"></a> [publish](#input\_publish) | Whether to publish creation/change as new Lambda Function Version. | `bool` | `false` | no |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | The amount of reserved concurrent executions for this Lambda Function. A value of 0 disables Lambda Function from being triggered and -1 removes any concurrency limitations. Defaults to Unreserved Concurrency Limits -1. | `number` | `-1` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of IAM role to use for Lambda Function. | `string` | `null` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Lambda Function runtime | `string` | `"nodejs18.x"` | no |
| <a name="input_snap_start"></a> [snap\_start](#input\_snap\_start) | (Optional) Snap start settings for low-latency startups | `bool` | `false` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The amount of time your Lambda Function has to run in seconds. | `number` | `3` | no |
| <a name="input_tracing_mode"></a> [tracing\_mode](#input\_tracing\_mode) | Tracing mode of the Lambda Function. Valid value can be either PassThrough or Active. | `string` | `null` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | List of security group ids when Lambda Function should run in the VPC. | `list(string)` | `null` | no |
| <a name="input_vpc_subnet_ids"></a> [vpc\_subnet\_ids](#input\_vpc\_subnet\_ids) | List of subnet ids when Lambda Function should run in the VPC. Usually private or intra subnets. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_cloudwatch_log_group_arn"></a> [lambda\_cloudwatch\_log\_group\_arn](#output\_lambda\_cloudwatch\_log\_group\_arn) | Lambda Cloudwatch Log group |
| <a name="output_lambda_cloudwatch_log_group_name"></a> [lambda\_cloudwatch\_log\_group\_name](#output\_lambda\_cloudwatch\_log\_group\_name) | Lambda Cloudwatch Log group |
| <a name="output_lambda_function_arn"></a> [lambda\_function\_arn](#output\_lambda\_function\_arn) | Lambda Function ARN |
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | Lambda Function Name |
| <a name="output_lambda_role_arn"></a> [lambda\_role\_arn](#output\_lambda\_role\_arn) | ARN of the IAM role created for the Lambda Function |
| <a name="output_lambda_role_name"></a> [lambda\_role\_name](#output\_lambda\_role\_name) | The name of the IAM role created for the Lambda Function |
| <a name="output_lambda_role_unique_id"></a> [lambda\_role\_unique\_id](#output\_lambda\_role\_unique\_id) | The unique id of the IAM role created for the Lambda Function |
<!-- END_TF_DOCS -->
