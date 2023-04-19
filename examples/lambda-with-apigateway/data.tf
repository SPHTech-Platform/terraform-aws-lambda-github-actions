
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