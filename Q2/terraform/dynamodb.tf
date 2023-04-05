resource "aws_dynamodb_table" "urls" {

  name           = var.dynamodb_table
  billing_mode   = "PROVISIONED"
  read_capacity  = var.dynamodb_table_read_cap
  write_capacity = var.dynamodb_table_write_cap
  hash_key       = "shorturl"
  range_key      = "created"

  attribute {
    name = "url"
    type = "S"
  }

  attribute {
    name = "shorturl"
    type = "S"
  }

  attribute {
    name = "created"
    type = "N"
  }

  global_secondary_index {
    name            = "LongURLIndex"
    hash_key        = "url"
    range_key       = "created"
    projection_type = "ALL"
    read_capacity  = var.dynamodb_table_read_cap
    write_capacity = var.dynamodb_table_write_cap
  }

  point_in_time_recovery { enabled = true }
  //  server_side_encryption { enabled = true }
  lifecycle { ignore_changes = [write_capacity, read_capacity] }

  tags = {
    Project     = var.project
    Environment = var.environment
    Region      = var.region
  }
}

module "table_autoscaling" {
  source     = "snowplow-devops/dynamodb-autoscaling/aws" // add the autoscaling module
  table_name = aws_dynamodb_table.urls.name               // apply autoscaling for the tf_notes_table
}

