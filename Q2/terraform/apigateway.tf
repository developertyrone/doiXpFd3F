resource "aws_api_gateway_rest_api" "shorturls_api_gateway" {
  name        = "Short URLs API"
  description = "API for managing short URLs."
  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    Project     = var.project
    Environment = var.environment
    Region      = var.region
  }
}

resource "aws_api_gateway_deployment" "shorturls_api_deployment" {
  depends_on = [aws_api_gateway_integration.shorturls_api_newurl, aws_api_gateway_integration.shorturls_api_geturl]
  rest_api_id = aws_api_gateway_rest_api.shorturls_api_gateway.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "shorturls_api_stage_prod" {
  rest_api_id = aws_api_gateway_rest_api.shorturls_api_gateway.id
  deployment_id = aws_api_gateway_deployment.shorturls_api_deployment.id
  stage_name = "${var.apigateway_stage}"
  cache_cluster_enabled = true
  cache_cluster_size = "${var.apigateway_cachesize}"
}




