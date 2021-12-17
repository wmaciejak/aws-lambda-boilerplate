variable "ci" {
  default = false
}

variable "root_rest_api_execution_arn" {
  type = string
}
variable "aws_access_key" {
  description = "AWS Access Key ID"
  default     = "123"
}

variable "aws_region" {
  description = "The AWS region"
  default     = "eu-west-1"
}

variable "aws_secret_key" {
  description = "AWS Secret Access Key"
  default     = "qwe"
  sensitive   = true
}

variable "localstack_url" {
  default = "http://localhost:4566"
}

variable "mode" {
  default = "localstack" # (localstack|aws)
}

variable "workspace" {
  description = "Workspace name"
  default     = ""
}
