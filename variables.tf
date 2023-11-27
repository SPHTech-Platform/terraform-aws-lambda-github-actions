variable "create_github_actions_oidc_provider" {
  description = "Controls Whether to create openid connect provider."
  type        = bool
  default     = false
}

variable "create_github_actions_role" {
  description = "Controls whether to create AWS OIDC integration GitHub Actions"
  type        = bool
  default     = true
}

variable "create_lambda_function_url" {
  description = "Controls whether the Lambda Function URL resource should be created"
  type        = bool
  default     = false
}

variable "create_github_actions_edge_role" {
  description = "Controls whether to create for lambda edge functions"
  type        = bool
  default     = false
}

variable "create_github_actions_signed_code_role" {
  description = "Controls whether to grant s3 access and signer access to GitHub Actions"
  type        = bool
  default     = false
}

variable "create_lambda_role" {
  description = "Controls whether the Lambda Role"
  type        = bool
  default     = true
}

variable "create_lambda_cloudwatch_log_group" {
  description = "Controls whether the Lambda Role"
  type        = bool
  default     = true
}

######################################
# AWS OIDC integration GitHub Actions
######################################
variable "github_repo" {
  description = "GitHub repo to grant access to assume a role via OIDC."
  type = object({
    repo         = string
    branches     = optional(list(string), [])
    environments = optional(list(string), ["*"])

    # Custom Role name. It will autocreate based on repo if not provided
    role_name = optional(string)
  })
}

variable "default_conditions" {
  description = "(Optional) Default condtions to apply, at least one of the following is madatory: 'allow_main', 'allow_environment', 'deny_pull_request' and 'allow_all'."
  type        = list(string)
  default     = ["allow_main", "allow_environment"]
}

# Refer https://github.com/terraform-aws-modules/terraform-aws-lambda/blob/master/variables.tf for additional vars
##################
# Lambda Function
##################
variable "lambda_at_edge" {
  description = "Set this to true if using Lambda@Edge, to enable publishing, limit the timeout, and allow edgelambda.amazonaws.com to invoke the function"
  type        = bool
  default     = false
}

variable "function_name" {
  description = "Lambda Function Name"
  type        = string
}

variable "description" {
  description = "Lambda Function Description"
  type        = string
  default     = ""
}
variable "handler" {
  description = "Lambda Function Index Handler"
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "Lambda Function runtime"
  type        = string
  default     = "nodejs18.x"
}

variable "lambda_role" {
  description = " IAM role ARN attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to. See Lambda Permission Model for more details."
  type        = string
  default     = ""
}

variable "architectures" {
  description = "Instruction set architecture for your Lambda function. Valid values are [\"x86_64\"] and [\"arm64\"]."
  type        = list(string)
  default     = null
}

variable "kms_key_arn" {
  description = "The ARN of KMS key to use by your Lambda Function"
  type        = string
  default     = null
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime. Valid value between 128 MB to 10,240 MB (10 GB), in 64 MB increments."
  type        = number
  default     = 128
}

variable "ephemeral_storage_size" {
  description = "Amount of ephemeral storage (/tmp) in MB your Lambda Function can use at runtime. Valid value between 512 MB to 10,240 MB (10 GB)."
  type        = number
  default     = 512
}

variable "publish" {
  description = "Whether to publish creation/change as new Lambda Function Version."
  type        = bool
  default     = false
}

variable "reserved_concurrent_executions" {
  description = "The amount of reserved concurrent executions for this Lambda Function. A value of 0 disables Lambda Function from being triggered and -1 removes any concurrency limitations. Defaults to Unreserved Concurrency Limits -1."
  type        = number
  default     = -1
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 3
}

variable "dead_letter_target_arn" {
  description = "The ARN of an SNS topic or SQS queue to notify when an invocation fails."
  type        = string
  default     = null
}

variable "layers" {
  description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function."
  type        = list(string)
  default     = null
}

variable "code_signing_config_arn" {
  description = "Amazon Resource Name (ARN) for a Code Signing Configuration"
  type        = string
  default     = null
}

variable "tracing_mode" {
  description = "Tracing mode of the Lambda Function. Valid value can be either PassThrough or Active."
  type        = string
  default     = null
}

variable "attach_tracing_policy" {
  description = "whether to attach tracing policy to lambda role"
  type        = bool
  default     = false
}

variable "environment_variables" {
  description = "A map that defines environment variables for the Lambda Function."
  type        = map(string)
  default     = {}
}

variable "vpc_subnet_ids" {
  description = "List of subnet ids when Lambda Function should run in the VPC. Usually private or intra subnets."
  type        = list(string)
  default     = null
}

variable "vpc_security_group_ids" {
  description = "List of security group ids when Lambda Function should run in the VPC."
  type        = list(string)
  default     = null
}

variable "package_type" {
  description = "The Lambda deployment package type. Valid options: Zip or Image"
  type        = string
  default     = "Zip"
}

variable "image_uri" {
  description = "The ECR image URI containing the function's deployment package."
  type        = string
  default     = null
}

variable "image_config_entry_point" {
  description = "The ENTRYPOINT for the docker image"
  type        = list(string)
  default     = []

}
variable "image_config_command" {
  description = "The CMD for the docker image"
  type        = list(string)
  default     = []
}

variable "image_config_working_directory" {
  description = "The working directory for the docker image"
  type        = string
  default     = null
}

variable "snap_start" {
  description = "(Optional) Snap start settings for low-latency startups"
  type        = bool
  default     = false
}

variable "source_path" {
  description = "The absolute path to a local file or directory containing your Lambda source code"
  type        = string
  default     = null
}

############################################
# Lambda Permissions (for allowed triggers)
############################################
variable "create_current_version_allowed_triggers" {
  description = "Whether to allow triggers on current version of Lambda Function (this will revoke permissions from previous version because Terraform manages only current resources)"
  type        = bool
  default     = true
}

variable "allowed_triggers" {
  description = "Map of allowed triggers to create Lambda permissions"
  type        = map(any)
  default     = {}
}

###############
# Function URL
###############
variable "create_unqualified_alias_lambda_function_url" {
  description = "Whether to use unqualified alias pointing to $LATEST version in Lambda Function URL"
  type        = bool
  default     = true
}

variable "authorization_type" {
  description = "The type of authentication that the Lambda Function URL uses. Set to 'AWS_IAM' to restrict access to authenticated IAM users only. Set to 'NONE' to bypass IAM authentication and create a public endpoint."
  type        = string
  default     = "NONE"
}

variable "cors" {
  description = "CORS settings to be used by the Lambda Function URL"
  type        = any
  default     = {}
}

variable "function_prefix" {
  description = "Prefix for the IAM role for lambda functions"
  type        = string
  default     = ""
}

variable "policy_jsons" {
  description = "List of additional policies for the lambda execution"
  type        = list(string)
  default     = []
}

variable "attach_policy_statements" {
  description = "Controls whether policy_jsons should be added to IAM role for Lambda Function"
  type        = bool
  default     = false
}

variable "policy_statements" {
  description = "Additional Inline Lambda Policy Statements"
  type        = any
  default     = {}
}

variable "role_name" {
  description = "Name of IAM role to use for Lambda Function."
  type        = string
  default     = null
}

###########
# Policies
###########
variable "attach_policy_jsons" {
  description = "Controls whether policy_jsons should be added to IAM role for Lambda Function"
  type        = bool
  default     = false
}

variable "attach_network_policy" {
  description = "Flag to attach network policy to use VPC subnet and security group"
  type        = bool
  default     = false
}

variable "number_of_policy_jsons" {
  description = "Number of policies JSON to attach to IAM role for Lambda Function"
  type        = number
  default     = 0
}

variable "attach_policy_json" {
  description = "Controls whether policy_json should be added to IAM role for Lambda Function"
  type        = bool
  default     = false
}

variable "policy_json" {
  description = "An additional policy document as JSON to attach to the Lambda Function role"
  type        = string
  default     = null
}

variable "attach_policies" {
  description = "Controls whether AWS managed policies should be added to IAM role for Lambda Function (e.g AWSLambdaBasicExecutionRole)"
  type        = bool
  default     = false
}

variable "managed_policy_arns" {
  description = "List of AWS managed policies to attach to IAM role for Lambda Function"
  type        = list(string)
  default     = null
}

variable "number_of_managed_policies" {
  description = "Number of AWS managed policies to attach to IAM role for Lambda Function"
  type        = number
  default     = 0
}

variable "signing_bucket_name" {
  description = "Name of the S3 bucket to store code for signing job"
  type        = string
  default     = null
}

variable "signing_profile_name" {
  description = "Name of the signer signing profile to use for signing job"
  type        = string
  default     = null
}

##################
# Cloudwatch Logs
##################
variable "cloudwatch_logs_retention_in_days" {
  description = "Number of days the cloudwatch logs will be retained. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653."
  type        = number
  default     = 7
}

#############################
# CloudFront (Edge Functions)
#############################

variable "cf_distribution_id" {
  description = "distribution id to allow oidc role to update edge functions that are attached"
  type        = string
  default     = null
}
