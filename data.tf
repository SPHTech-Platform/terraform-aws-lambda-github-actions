data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "update_lambda" {
  #checkov:skip=CKV_AWS_356: Read only
  statement {
    sid = "ReadLambda"

    actions = [
      "lambda:Get*",
      "lambda:List*",
    ]

    resources = ["*"]
  }

  statement {
    sid = "LambdaUpdateEvent"

    actions = [
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionConfiguration",
      "lambda:UpdateAlias",
      "lambda:PublishVersion",
      "lambda:PublishLayerVersion"
    ]
    resources = ["arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${var.function_prefix}*"]
  }
}

data "aws_iam_policy_document" "update_lambda_edge" {
  statement {
    sid = "EnableCFReplication"

    actions = [
      "lambda:GetFunction",
      "lambda:EnableReplication"
    ]

    resources = [
      "arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:viewer_request_${var.environment}:*",
      "arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:origin_response_${var.environment}:*"
    ]
  }

  dynamic "statement" {
    for_each = var.cf_distribution_id != null ? [0] : []
    content {
      id = "AllowCloudFrontUpdateDistributionAccess"

      actions = [
        "cloudfront:UpdateDistribution",
        "cloudfront:GetDistribution",
        "cloudfront:GetDistributionConfig"
      ]

      resources = [
        "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${var.cf_distribution_id}"
      ]

    }
  }
}
