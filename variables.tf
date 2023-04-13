variable "app_metadata" {
  description = "Application component prefix, name used to generate resource names"
  type = object({
    prefix = string
    name   = string
    env    = string
  })

  validation {
    condition     = can(regex("^dev$|^qa$|^uat$|^prd$", var.app_metadata.env))
    error_message = "Err: invalid env, must be one of dev|qa|uat|prd."
  }
}

variable "function_name" {
  description = "Lambda Function Name"
  type        = string
}

variable "function_description" {
  description = "Lambda Function Description"
  type        = string
  default     = ""
}
variable "function_index_handler" {
  description = "Lambda Function Index Handler"
  type        = string
  default     = "index.handler"
}

variable "lambda_runtime" {
  description = "Lambda Function runtime"
  type        = string
  default     = "nodejs18.x"
}

variable "lambda_environment_variables" {
  description = "A map that defines environment variables for the Lambda Function."
  type        = map(string)
  default     = {}
}

variable "allowed_triggers" {
  description = "Map of allowed triggers to create Lambda permissions"
  type        = map(any)
  default     = {}
}
variable "authorization_type" {
  description = "The type of authentication that the Lambda Function URL uses. Set to 'AWS_IAM' to restrict access to authenticated IAM users only. Set to 'NONE' to bypass IAM authentication and create a public endpoint."
  type        = string
  default     = "AWS_IAM"
}

variable "cors" {
  description = "CORS settings to be used by the Lambda Function URL"
  type        = any
  default     = {}
}

variable "github_repo" {
  description = "GitHub repository to grant access to assume a role via OIDC."
  type        = string
}

variable "github_environments" {
  description = "(Optional) Allow GitHub action to deploy to all (default) or to one of the environments in the list."
  type        = list(string)
  default     = ["*"]
}

variable "github_branches" {
  description = "List of github branches allowed for oidc subject claims."
  type        = list(string)
  default     = []
}

variable "additional_deployer_role" {
  description = "(Optional) Additional Deployer Policy Role"
  type        = list(any)
  default     = []
}

variable "role_name" {
  description = "(Optional) role name of the created role, if not provided the github_repo will be used to generate."
  type        = string
  default     = null
}

variable "create_gha_deployer" {
  description = "Flag for creating Github Actions Deployer deployer"
  type        = bool
  default     = true
}

variable "function_prefix" {
  description = "Prefix for the IAM role for lambda functions"
  type        = string
  default     = ""
}

variable "addition_lambda_policy" {
  description = "List of additional policies for the lambda execution"
  type        = list(string)
  default     = []
}

variable "additional_lambda_policy_statements" {
  description = "Additional Inline Lambda Policy Statements"
  type        = any
  default     = {}
}

variable "vpc_subnet_ids" {
  description = "List of Subnet Ids"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "Listof Security Groups"
  type        = list(string)
}

variable "attach_network_policy" {
  description = "Flag to attach network policy to use VPC subnet and security group"
  type        = bool
  default     = true
}
