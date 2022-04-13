provider "aws" {
  region = var.region
}

module "s3_bucket" {
  source                 = "clouddrove/s3/aws"
  version                = "0.15.1"

  name                   = var.bucket_name
  environment            = var.environment
  label_order            = ["environment", "name"]

  versioning             = false
  acl                    = "private"
  force_destroy          = true
}

module "sftp" {
  source                 = "clouddrove/sftp/aws"
  version                = "1.0.1"
  name                   = "sftp"
  environment            = var.environment
  label_order            = ["environment", "name"]

  enable_sftp            = true
  public_key             = var.public_key
  user_name              = var.user_name
  sub_folder             = var.sub_folder
  s3_bucket_id           = module.s3_bucket.id
  endpoint_type          = "PUBLIC"
}

module "lambda" {
  source                 = "./modules/lambda"
  environment            = "dev"
  function_name          = "S3_Notifier"
  handler_name           = "lambda_function"
  runtime                = "python3.6"
  timeout                = "900"
  bucket_name            = format("%s-%s", var.environment, var.bucket_name)
  lambda_role_name       = "s3_notifer_lambda_iam_role"
  lambda_iam_policy_name = "s3_notifer_lambda_iam_policy"
  bucket_id              =  module.s3_bucket.id

}