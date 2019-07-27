/**
 * Configure the AWS Provider
 */
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

/**
 * Initialize the project
 */
module "project" {
  source  = "PGBI/project/aws"
  version = "~>0.1.0"

  name     = "myproject"
  vcs_repo = "github.com/account/project"
}

/**
 * Create a lambda function whose name will be "prod-myproject-hello" if the terraform workspace is "prod".
 */
module "lambda" {
  source  = "PGBI/big-lambda-function/aws"
  version = "~>0.1.0"

  description = "Node hello world lambda."
  name        = "js-hello"
  runtime     = "nodejs10.x"
  project     = module.project
  src_path    = "${path.module}/dist"
  env_vars = {
    ENV = terraform.workspace
  }
}
