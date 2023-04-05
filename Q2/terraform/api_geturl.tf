resource "aws_api_gateway_resource" "shorturls_api_resource_geturl" {
  rest_api_id = aws_api_gateway_rest_api.shorturls_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.shorturls_api_gateway.root_resource_id
  path_part   = "{shorturl}"
}

resource "aws_api_gateway_method" "shorturls_api_geturl" {
  rest_api_id = aws_api_gateway_rest_api.shorturls_api_gateway.id
  resource_id      = aws_api_gateway_resource.shorturls_api_resource_geturl.id
  http_method   = "GET"
  authorization = "NONE"
  //  api_key_required = true
}

resource "aws_api_gateway_integration" "shorturls_api_geturl" {
  rest_api_id             = aws_api_gateway_rest_api.shorturls_api_gateway.id
  resource_id             = aws_api_gateway_resource.shorturls_api_resource_geturl.id
  http_method             = aws_api_gateway_method.shorturls_api_geturl.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
//  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.geturl.arn}/invocations"
  uri                     = aws_lambda_function.geturl.invoke_arn
}

