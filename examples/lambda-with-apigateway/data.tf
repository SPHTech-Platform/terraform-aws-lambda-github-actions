
data "aws_subnets" "lambda" {
  filter {
    name   = "vpc-id"
    values = ["vpc-abcdefg"]
  }

  filter {
    name   = "tag:Name"
    values = ["WebA", "WebB"]
  }
}

data "aws_security_groups" "lambda" {
  filter {
    name   = "vpc-id"
    values = ["vpc-abcdefg"]
  }

  filter {
    name   = "group-name"
    values = ["SG-EC2-Web&App"]
  }
}

data "aws_iam_policy_document" "access_s3" {
  statement {
    sid = "LambdaAccessS3"
    actions = [
      "s3:ListBucket",
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::example-bucket-s3",
      "arn:aws:s3:::example-bucket-s3/*"
    ]
  }
}
