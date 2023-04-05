resource "aws_iam_role" "shorturls_lambda_iam" {
  name               = "shorturls_lambda_iam"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "template_file" "shorturls_lambda_policy" {
  template = file("${path.module}/policy.json")
  vars = {
    dynamodb_table = "${var.dynamodb_table}"
  }
}

resource "aws_iam_role_policy" "shorturls_lambda_policy" {
  name   = "short_url_lambda_policy"
  role   = aws_iam_role.shorturls_lambda_iam.id
  policy = data.template_file.shorturls_lambda_policy.rendered
}
