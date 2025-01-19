variable "aws_account_id" {
  description = "aws account id for account"
  type        = string
  default     = ""
}

variable "region" {
  description = "AWS region that we are going to deploy our resources to"
  type        = string
  default     = "us-east-1"
}

variable "log_group_name" {
  description = "The name of the CloudWatch log group"
  type        = string
  default     = "ECS_DISCORD-BOT-LOG_GROUP"
}

variable "retention_days" {
  description = "The number of days to retain the logs in the CloudWatch log group"
  type        = number
  default     = 7
}