data "archive_file" "geturl" {
  type        = "zip"
  source_dir  = "lambda_functions/geturl"
  output_path = "lambda_functions/geturl.zip"
}


resource "aws_lambda_permission" "shorturls_lambda_permssion_geturl" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.geturl.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.shorturls_api_gateway.id}/*/${aws_api_gateway_method.shorturls_api_geturl.http_method}${aws_api_gateway_resource.shorturls_api_resource_geturl.path}"
}

resource "aws_lambda_function" "geturl" {
  filename         = "lambda_functions/geturl.zip"
  function_name    = "geturl"
  role             = aws_iam_role.shorturls_lambda_iam.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.geturl.output_base64sha256
  runtime          = "python3.9"

  environment {
    variables = {
      DYNAMODB_TABLE = "${var.dynamodb_table}"
      REGION         = "${var.region}"
      LAMBDA_CACHESIZE = "${var.lambda_cachesize}"
      LAMBDA_CACHETTL = "${var.lambda_cachettl}"
    }
  }
  tags = {
    Project     = var.project
    Environment = var.environment
    Region      = var.region
  }
}