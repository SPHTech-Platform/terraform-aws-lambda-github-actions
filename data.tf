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
      "lambda:PublishLayerVersion",
      "lambda:PutProvisionedConcurrencyConfig",
      "lambda:DeleteProvisionedConcurrencyConfigCommand",
    ]
    resources = ["arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${var.function_prefix}*"]
  }
}

data "aws_iam_policy_document" "update_lambda_edge" {
  statement {
    sid = "EnableCFReplication"

    actions = [
      "lambda:GetFunction",
      "lambda:EnableReplication",
    ]

    resources = [
      "arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:${var.function_name}:*",
      "arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:${var.function_name}:*",
    ]
  }

  dynamic "statement" {
    for_each = var.cf_distribution_id == null ? [] : [1]
    content {
      sid = "AllowCloudFrontUpdateDistributionAccess"

      actions = [
        "cloudfront:UpdateDistribution",
        "cloudfront:GetDistribution",
        "cloudfront:GetDistributionConfig",
      ]

      resources = [
        "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${var.cf_distribution_id}",
      ]

    }
  }
}

data "aws_iam_policy_document" "sign_code" {
  #checkov:skip=CKV_AWS_356:Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions
  count = var.create_github_actions_signed_code_role ? 1 : 0

  statement {
    sid = "UploadToS3"

    actions = [
      "s3:PutObjectTagging",
      "s3:PutObjectAcl",
      "s3:PutObject",
      "s3:GetObjectVersion",
      "s3:GetObjectTagging",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${var.signing_bucket_name}/*",
    ]
  }

  statement {
    sid = "ListBucket"

    actions = [
      "s3:ListBucket",
      "s3:ListBucketVersions",
    ]

    resources = [
      "arn:aws:s3:::${var.signing_bucket_name}",
    ]
  }

  statement {
    sid = "ListSignerSigningProfileJobs"

    # These action only support all the resources wildcard "*"
    actions = [
      "signer:ListSigningJobs",
      "signer:ListSigningProfiles",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "DescribeSigningJob"

    actions = [
      "signer:DescribeSigningJob",
    ]

    resources = [
      "arn:aws:signer:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:/signing-jobs/*",
    ]
  }

  statement {
    sid = "SignCode"

    actions = [
      "signer:StartSigningJob",
      "signer:GetSigningProfile",
    ]

    resources = [
      "arn:aws:signer:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:/signing-profiles/${var.signing_profile_name}",
    ]
  }
}
