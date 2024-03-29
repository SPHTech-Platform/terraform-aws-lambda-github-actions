# test function for the lambda module
module "home_feed" {
  source = "../../"

  create_github_actions_oidc_provider     = true
  create_lambda_function_url              = true
  create_current_version_allowed_triggers = false

  github_repo = {
    repo = "SPHTech-Platform/home-feed"
  }

  function_name = "home-feed"
  description   = "Home Feed"
  handler       = "bin/serverless"
  runtime       = "go1.x"

  environment_variables = {
    "ENV" = "dev"
  }

  deployer_lambda_additional_permission = data.aws_iam_policy_document.access_s3.json

  vpc_subnet_ids         = data.aws_subnets.lambda.ids
  vpc_security_group_ids = data.aws_security_groups.lambda.ids
  attach_network_policy  = true

  allowed_triggers = {
    APIGatewayGet = {
      service    = "apigateway"
      source_arn = "arn:aws:execute-api:ap-southeast-1:123456789101:abcdefghij/*/GET/feed/home"
    }
    APIGatewayPost = {
      service    = "apigateway"
      source_arn = "arn:aws:execute-api:ap-southeast-1:123456789101:abcdefghij/*/POST/feed/home"
    }
  }

}
