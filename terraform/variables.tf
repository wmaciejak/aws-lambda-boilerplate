variable "api_gateway_deployment_stage_name" {
  description = ""
  default     = "dev"
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

variable "workspace" {
  description = "Workspace name" # e.g. sec-001
  default     = ""
}
