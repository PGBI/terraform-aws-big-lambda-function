variable "project" {
  description = "Reference to a \"project\" module. See: https://registry.terraform.io/modules/PGBI/project/aws/"
}

variable "name" {
  type        = "string"
  description = "Name of the function."
}

variable "description" {
  type        = "string"
  description = "Description of what the Lambda Function does."
}

variable "runtime" {
  type        = "string"
  description = "The function's runtime. See https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime for possible values."
}

variable "memory_size" {
  default     = "128"
  description = "Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128."
}

variable "src_path" {
  type        = "string"
  description = "Path to the function's deployment package within the local filesystem. The module will take care of zipping and shipping the package to AWS. This module expects the package to contain a file called main.[py/js/... depending on the runtime] containing a function called \"handler\" which will be the entrypoint of your lambda function."
}

variable "timeout" {
  type        = "string"
  description = "The amount of time your Lambda Function has to run in seconds."
  default     = "30"
}

variable "logs_retention_in_days" {
  description = "Specifies the number of days you want to retain log events the lambda function is shipping to cloudwatch logs."
  default     = "14"
}

variable "env_vars" {
  type        = map(string)
  default     = {}
  description = "A map that defines environment variables for the Lambda function."
}
