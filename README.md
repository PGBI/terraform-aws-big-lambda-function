# AWS Big Lambda Function module

## Description

This module is a simple wrapper around the `aws_lambda_function` aws resource. It creates:
 * an encrypted s3 bucket where the lambda deployment package will be stored,
 * a lambda function whose name is namespaced with the terraform workspace and the project name,
 * a cloudwatch log group the lambda function will ship its logs to.

If your lambda deployment package is small (< 10Mb), consider using the [lambda-function](https://registry.terraform.io/modules/PGBI/lambda-function/aws/)
module instead, which won't create the s3 bucket and directly upload the deployment package to AWS lambda.

## Usage

```hcl
module "project" {
  source  = "PGBI/project/aws"
  version = "~>0.2.0"

  name     = "myproject"
  vcs_repo = "github.com/account/project"
}

/**
 * Create a lambda function whose name will be "prod-myproject-hello" if the terraform workspace is "prod".
 */
module "lambda" {
  source  = "PGBI/big-lambda-function/aws"
  version = "~>0.1.0"

  description = "Python hello world lambda."
  name        = "hello"
  runtime     = "python3.7"
  project     = module.project
  src_path    = "${path.module}/dist"
  env_vars    = {
    ENV = terraform.workspace
  }
}
```
