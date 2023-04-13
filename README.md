# Github Actions Lambda Deployer Terraform module

Terraform module for creating the lambda and the github actions IAM Role deployer to deploy the lambda code

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.27 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.3.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.62.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_deployer_role_policy"></a> [deployer\_role\_policy](#module\_deployer\_role\_policy) | terraform-aws-modules/iam/aws//modules/iam-policy | >= 5.3.0 |
| <a name="module_github_actions_repo"></a> [github\_actions\_repo](#module\_github\_actions\_repo) | philips-labs/github-oidc/aws | >= 0.3.0 |
| <a name="module_lambda"></a> [lambda](#module\_lambda) | terraform-aws-modules/lambda/aws | ~> 4.10.1 |

## Resources

| Name | Type |
|------|------|
| [archive_file.dummy](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |
| [aws_iam_policy_document.deployer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.deployer_concat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addition_lambda_policy"></a> [addition\_lambda\_policy](#input\_addition\_lambda\_policy) | List of additional policies for the lambda execution | `list(string)` | `[]` | no |
| <a name="input_additional_deployer_role"></a> [additional\_deployer\_role](#input\_additional\_deployer\_role) | (Optional) Additional Deployer Policy Role | `list(any)` | `[]` | no |
| <a name="input_additional_lambda_policy_statements"></a> [additional\_lambda\_policy\_statements](#input\_additional\_lambda\_policy\_statements) | Additional Inline Lambda Policy Statements | `any` | `{}` | no |
| <a name="input_allowed_triggers"></a> [allowed\_triggers](#input\_allowed\_triggers) | Map of allowed triggers to create Lambda permissions | `map(any)` | `{}` | no |
| <a name="input_app_metadata"></a> [app\_metadata](#input\_app\_metadata) | Application component prefix, name used to generate resource names | <pre>object({<br>    prefix = string<br>    name   = string<br>    env    = string<br>  })</pre> | n/a | yes |
| <a name="input_authorization_type"></a> [authorization\_type](#input\_authorization\_type) | The type of authentication that the Lambda Function URL uses. Set to 'AWS\_IAM' to restrict access to authenticated IAM users only. Set to 'NONE' to bypass IAM authentication and create a public endpoint. | `string` | `"AWS_IAM"` | no |
| <a name="input_cors"></a> [cors](#input\_cors) | CORS settings to be used by the Lambda Function URL | `any` | `{}` | no |
| <a name="input_create_gha_deployer"></a> [create\_gha\_deployer](#input\_create\_gha\_deployer) | Flag for creating Github Actions Deployer deployer | `bool` | `true` | no |
| <a name="input_function_description"></a> [function\_description](#input\_function\_description) | Lambda Function Description | `string` | `""` | no |
| <a name="input_function_index_handler"></a> [function\_index\_handler](#input\_function\_index\_handler) | Lambda Function Index Handler | `string` | `"index.handler"` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Lambda Function Name | `string` | n/a | yes |
| <a name="input_function_prefix"></a> [function\_prefix](#input\_function\_prefix) | Prefix for the IAM role for lambda functions | `string` | `""` | no |
| <a name="input_github_branches"></a> [github\_branches](#input\_github\_branches) | List of github branches allowed for oidc subject claims. | `list(string)` | `[]` | no |
| <a name="input_github_environments"></a> [github\_environments](#input\_github\_environments) | (Optional) Allow GitHub action to deploy to all (default) or to one of the environments in the list. | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_github_repo"></a> [github\_repo](#input\_github\_repo) | GitHub repository to grant access to assume a role via OIDC. | `string` | n/a | yes |
| <a name="input_lambda_environment_variables"></a> [lambda\_environment\_variables](#input\_lambda\_environment\_variables) | A map that defines environment variables for the Lambda Function. | `map(string)` | `{}` | no |
| <a name="input_lambda_runtime"></a> [lambda\_runtime](#input\_lambda\_runtime) | Lambda Function runtime | `string` | `"nodejs18.x"` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | (Optional) role name of the created role, if not provided the github\_repo will be used to generate. | `string` | `null` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | Listof Security Groups | `list(string)` | n/a | yes |
| <a name="input_vpc_subnet_ids"></a> [vpc\_subnet\_ids](#input\_vpc\_subnet\_ids) | List of Subnet Ids | `list(string)` | n/a | yes |

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
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
