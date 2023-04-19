# test function for the lambda module
module "home-feed" {
  source = "../../"

  create_github_actions_oidc_provider = true
  create_lambda_function_url = true

  github_repo = {
    repo = "SPHTech-Platform/home-feed"
  }
  
  function_name = "home-feed"
  description = "Home Feed"
  handler = "bin/serverless"
  runtime = "go1.x"
  
  environment_variables = {
    "ENV" = "dev"
  }

  vpc_subnet_ids         = data.aws_subnets.lambda.ids
  vpc_security_group_ids = data.aws_security_groups.lambda.ids
  attach_network_policy = true

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