# outputs.tf
# Output values displayed after terraform apply completes

output "guardduty_detector_id" {
  description = "GuardDuty Detector ID"
  value       = aws_guardduty_detector.soc_detector.id
}

output "cloudtrail_arn" {
  description = "CloudTrail ARN"
  value       = aws_cloudtrail.soc_trail.arn
}

output "cloudtrail_s3_bucket" {
  description = "S3 bucket storing CloudTrail logs"
  value       = aws_s3_bucket.cloudtrail_logs.bucket
}

output "sns_topic_arn" {
  description = "SNS Topic ARN for SOC alerts"
  value       = aws_sns_topic.soc_alerts.arn
}

output "cloudwatch_alarm_name" {
  description = "CloudWatch alarm monitoring GuardDuty findings"
  value       = aws_cloudwatch_metric_alarm.guardduty_findings.alarm_name
}

output "cloudwatch_log_group" {
  description = "CloudWatch Log Group for SOC lab"
  value       = aws_cloudwatch_log_group.soc_logs.name
}