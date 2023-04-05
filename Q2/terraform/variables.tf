variable "environment" {
  type        = string
  default     = "dev"
  description = "The environment of the application deployment"
}
variable "project" {
  type        = string
  default     = "shorturls"
  description = "The Application project name"
}
variable "region" {
  type        = string
  default     = "ap-east-1"
  description = "The AWS reegion to use for the Short URL project"
}

variable "apigateway_stage" {
  type        = string
  default     = "prod"
  description = "The API Gateway stage name for the release"
}

variable "apigateway_cachesize" {
  type        = string
  default     = "0.5"
  description = "The cachesize for the release stage"
}

variable "lambda_cachesize" {
  type        = string
  default     = "1024"
  description = "The cachesize for the lambda local cache"
}

variable "lambda_cachettl" {
  type        = string
  default     = "10"
  description = "The cachesize for the lambda local cache ttl"
}

variable "dynamodb_table" {
  type        = string
  default     = "urls"
  description = "The dynamo table to store the urls and shorturls"
}
variable "dynamodb_table_read_cap" {
  type        = number
  default     = 10
  description = "The dynamo table read capacity"
}
variable "dynamodb_table_write_cap" {
  type        = number
  default     = 10
  description = "The dynamo table write capacity"
}

//variable "short_url_domain" {
//  type        = string
//  description = "The domain name to use for short URLs."
//}