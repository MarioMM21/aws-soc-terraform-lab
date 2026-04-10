# main.tf
# AWS SOC Automation Lab — Terraform
# Provisions GuardDuty, CloudTrail, CloudWatch, and SNS alerting

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

# --- S3 Bucket for CloudTrail Logs ---
resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket        = "${var.project_name}-cloudtrail-logs-${var.account_id}"
  force_destroy = true

  tags = {
    Name        = "${var.project_name}-cloudtrail-logs"
    Environment = "Lab"
    Project     = var.project_name
  }
}

resource "aws_s3_bucket_policy" "cloudtrail_logs_policy" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.cloudtrail_logs.arn
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.cloudtrail_logs.arn}/AWSLogs/${var.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

# --- CloudTrail ---
resource "aws_cloudtrail" "soc_trail" {
  name                          = "${var.project_name}-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs.id
  include_global_service_events = true
  is_multi_region_trail         = false
  enable_logging                = true

  tags = {
    Name    = "${var.project_name}-trail"
    Project = var.project_name
  }

  depends_on = [aws_s3_bucket_policy.cloudtrail_logs_policy]
}

# --- GuardDuty ---
resource "aws_guardduty_detector" "soc_detector" {
  enable = true

  tags = {
    Name    = "${var.project_name}-guardduty"
    Project = var.project_name
  }
}

# --- SNS Topic for Alerts ---
resource "aws_sns_topic" "soc_alerts" {
  name = "${var.project_name}-alerts"

  tags = {
    Name    = "${var.project_name}-alerts"
    Project = var.project_name
  }
}

resource "aws_sns_topic_subscription" "soc_alerts_email" {
  topic_arn = aws_sns_topic.soc_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# --- CloudWatch Alarm for GuardDuty Findings ---
resource "aws_cloudwatch_metric_alarm" "guardduty_findings" {
  alarm_name          = "${var.project_name}-guardduty-findings"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FindingCount"
  namespace           = "AWS/GuardDuty"
  period              = 300
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "Alert when GuardDuty findings are detected"
  alarm_actions       = [aws_sns_topic.soc_alerts.arn]

  tags = {
    Name    = "${var.project_name}-guardduty-alarm"
    Project = var.project_name
  }
}

# --- CloudWatch Log Group ---
resource "aws_cloudwatch_log_group" "soc_logs" {
  name              = "/aws/soc-lab/${var.project_name}"
  retention_in_days = 7

  tags = {
    Name    = "${var.project_name}-logs"
    Project = var.project_name
  }
}