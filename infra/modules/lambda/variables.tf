#Create Variables
variable "function_name" {
  default = ""
}
variable "handler_name" {
  default = ""
}
variable "runtime" {
  default = ""
}
variable "timeout" {
  default = ""
}

variable "lambda_role_name" {
  default = ""
}

variable "lambda_iam_policy_name" {
  default = ""
}

variable "bucket_id" {
  default = ""
}
variable "bucket_name" {
  default = ""
}
variable "environment" {
  default = "dev"
}