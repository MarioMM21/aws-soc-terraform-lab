# variables.tf
# Variable definitions for AWS SOC Automation Lab

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
  default     = "soc-lab"
}

variable "account_id" {
  description = "Your AWS account ID — used for S3 bucket naming and policies"
  type        = string
}

variable "alert_email" {
  description = "Email address to receive SOC alert notifications"
  type        = string
}