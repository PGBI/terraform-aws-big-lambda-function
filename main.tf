terraform {
  required_version = ">= 0.12"
}

provider "archive" {
  version = "~> 1.2"
}

/**
 * Log group the lambda function will ship its logs to.
 */
module "log_group" {
  source  = "PGBI/cloudwatch-log-group/aws"
  version = "~>0.1.0"

  name              = "/aws/lambda/${var.project.name_prefix}-${var.name}"
  no_name_prefix    = true
  retention_in_days = var.logs_retention_in_days
  project           = var.project
}

/**
 * Zipping the lambda package.
 */
data "archive_file" "lambda_source" {
  type        = "zip"
  source_dir  = var.src_path
  output_path = "/tmp/${md5(var.src_path)}.zip"
}

/**
 * The S3 bucket where the lambda package will be stored
 */
module "source_store" {
  source  = "PGBI/simple-private-bucket/aws"
  version = "~>0.1.0"

  name    = "${var.name}-lambda-src"
  project = var.project
}

/**
 * Storing the lambda package in the s3 bucket
 */
resource "aws_s3_bucket_object" "package" {
  source = data.archive_file.lambda_source.output_path
  key    = "package.zip"
  bucket = module.source_store.name
  etag   = data.archive_file.lambda_source.output_md5
}

/**
 * Role assumed by the lambda function.
 */
module "role" {
  source  = "PGBI/iam-role/aws"
  version = "~>0.1.0"

  description = "Role assumed by the lambda function \"${var.project.name_prefix}-${var.name}\"."
  name        = "${var.name}-lambda"
  project     = var.project

  trusted_services = ["lambda.amazonaws.com"]
}

module "role_policy" {
  source  = "PGBI/iam-role-policy/aws"
  version = "~>0.1.0"

  name      = "manage_logs"
  role_name = module.role.name
  statements = [{
    actions   = ["logs:DescribeLogGroups"]
    resources = ["arn:aws:logs:*:${var.project.account_id}:*"]
    effect    = "Allow"
    }, {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [module.log_group.arn]
    effect    = "Allow"
    }
  ]
}

/**
 * The lambda function
 */
resource "aws_lambda_function" "main" {
  function_name     = "${var.project.name_prefix}-${var.name}"
  description       = var.description
  handler           = "main.handler"
  role              = module.role.arn
  runtime           = var.runtime
  memory_size       = var.memory_size
  layers            = var.layers_arns
  timeout           = var.timeout
  s3_bucket         = module.source_store.name
  s3_key            = aws_s3_bucket_object.package.key
  s3_object_version = aws_s3_bucket_object.package.version_id

  dynamic "environment" {
    for_each = length(var.env_vars) > 0 ? ["foo"] : []
    content {
      variables = var.env_vars
    }
  }

  tags = var.project.tags
}
