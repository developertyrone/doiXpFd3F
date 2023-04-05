data "archive_file" "newurl" {
  type        = "zip"
  source_dir  = "lambda_functions/newurl"
  output_path = "lambda_functions/newurl.zip"
}


resource "aws_lambda_permission" "shorturls_lambda_permssion_newurl" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.newurl.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.shorturls_api_gateway.id}/*/${aws_api_gateway_method.shorturls_api_newurl.http_method}${aws_api_gateway_resource.shorturls_api_resource_newurl.path}"
  //  source_arn = "${aws_api_gateway_rest_api.product_apigw.execution_arn}/*/POST/product"

}

resource "aws_lambda_function" "newurl" {
  filename         = "lambda_functions/newurl.zip"
  function_name    = "newurl"
  role             = aws_iam_role.shorturls_lambda_iam.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.newurl.output_base64sha256
  runtime          = "python3.9"
  memory_size      = "${var.lambda_memory}"

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