locals {
  iam_role_name_prefix = replace(var.github_repo, "/", "-")
}

module "deployer_role_policy" {
  count = var.create_gha_deployer ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = ">= 5.3.0"

  create_policy = true

  name        = format("%s%s", substr(local.iam_role_name_prefix, 0, 52), "-gha-deployer")
  path        = "/"
  description = "deployer IAM Policy"
  policy      = data.aws_iam_policy_document.deployer_concat.json
}

module "github_actions_repo" {
  count = var.create_gha_deployer ? 1 : 0

  source  = "philips-labs/github-oidc/aws"
  version = ">= 0.3.0"

  openid_connect_provider_arn = data.aws_iam_openid_connect_provider.github.arn
  repo                        = var.github_repo
  role_name                   = var.role_name
  default_conditions          = ["allow_environment", "allow_main"]
  github_environments         = var.github_environments

  conditions = (length(var.github_branches) > 0) ? [
    {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [for branch in var.github_branches : "repo:${var.github_repo}:ref:refs/heads/${branch}"]
    },
  ] : []

  role_policy_arns = [
    module.deployer_role_policy[0].arn,
  ]
}
