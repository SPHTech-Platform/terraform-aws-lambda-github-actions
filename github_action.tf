module "oidc_provider" {
  source  = "philips-labs/github-oidc/aws//modules/provider"
  version = "~> 0.7.0"

  count = var.create_github_actions_oidc_provider ? 1 : 0
}

module "lambda_gha" {
  source  = "philips-labs/github-oidc/aws"
  version = "~> 0.7.0"

  count = var.create_github_actions_role ? 1 : 0

  openid_connect_provider_arn = var.create_github_actions_oidc_provider ? module.oidc_provider[0].openid_connect_provider.arn : data.aws_iam_openid_connect_provider.github.arn
  repo                        = var.github_repo.repo
  role_name                   = var.github_repo.role_name
  github_environments         = var.github_repo.environments

  default_conditions = var.default_conditions

  conditions = length(var.github_repo.branches) > 0 || length(var.github_repo.tags) > 0 ? [
    {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = compact(concat([for branch in var.github_repo.branches : "repo:${var.github_repo.repo}:ref:refs/heads/${branch}"], [for tag in var.github_repo.tags : "repo:${var.github_repo.repo}:ref:refs/tags/${tag}"]))
    }
  ] : []
}

moved {
  from = module.lamda_gha
  to   = module.lambda_gha
}

resource "aws_iam_role_policy" "update_lambda" {
  count = var.create_github_actions_role ? 1 : 0

  name_prefix = "UpdateLambda"
  role        = module.lambda_gha[0].role.name
  policy      = data.aws_iam_policy_document.update_lambda_combined.json
}

resource "aws_iam_role_policy" "update_lambda_edge" {
  count = var.create_github_actions_edge_role ? 1 : 0

  name_prefix = "UpdateLambdaEdge"
  role        = module.lambda_gha[0].role.name
  policy      = data.aws_iam_policy_document.update_lambda_edge_combined.json
}

resource "aws_iam_role_policy" "sign_code" {
  count = var.create_github_actions_signed_code_role ? 1 : 0

  name_prefix = "SignCode"
  role        = module.lambda_gha[0].role.name
  policy      = data.aws_iam_policy_document.sign_code[0].json
}
