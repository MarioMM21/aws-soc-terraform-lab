\# 03 — Deployment



\## Overview

This document covers the AWS resources deployed by Terraform and

verification of each service in the AWS console.



\## Resources Deployed



\### 1. S3 Bucket — CloudTrail Log Storage

\*\*Resource:\*\* aws\_s3\_bucket

\*\*Name:\*\* soc-lab-cloudtrail-logs-\[account-id]

\*\*Purpose:\*\* Stores all CloudTrail audit logs securely



Configuration:

\- Server side encryption enabled (AES256)

\- Force destroy enabled for lab cleanup

\- Bucket policy restricts access to CloudTrail service only



Verify in console:

1\. Go to AWS Console → S3 → Buckets

2\. Look for soc-lab-cloudtrail-logs bucket

3\. Confirm bucket exists and encryption is enabled



\---



\### 2. S3 Bucket Policy

\*\*Resource:\*\* aws\_s3\_bucket\_policy

\*\*Purpose:\*\* Restricts bucket access to CloudTrail service only



Policy allows:

\- CloudTrail to check bucket ACL (GetBucketAcl)

\- CloudTrail to write logs (PutObject)

\- No other principals have access



\---



\### 3. CloudTrail

\*\*Resource:\*\* aws\_cloudtrail

\*\*Name:\*\* soc-lab-trail

\*\*Purpose:\*\* Logs all AWS API activity across the account



Configuration:

\- Global service events included

\- Logging enabled immediately after deployment

\- Logs stored in S3 bucket



Verify in console:

1\. Go to AWS Console → CloudTrail → Trails

2\. Look for soc-lab-trail

3\. Confirm status shows Logging



\---



\### 4. GuardDuty Detector

\*\*Resource:\*\* aws\_guardduty\_detector

\*\*Purpose:\*\* AI-powered threat detection for the AWS account



Configuration:

\- Detector enabled immediately after deployment

\- Monitors CloudTrail, VPC Flow Logs, and DNS logs

\- 30-day free trial on new accounts



Verify in console:

1\. Go to AWS Console → GuardDuty → Summary

2\. Confirm detector status shows Active

3\. Note the detector ID matches Terraform output



\---



\### 5. SNS Topic — SOC Alerts

\*\*Resource:\*\* aws\_sns\_topic

\*\*Name:\*\* soc-lab-alerts

\*\*Purpose:\*\* Sends email notifications when threats are detected



Configuration:

\- Email subscription created automatically by Terraform

\- Subscription must be confirmed via email link

\- Triggered by CloudWatch alarm on GuardDuty findings



Verify in console:

1\. Go to AWS Console → SNS → Topics

2\. Look for soc-lab-alerts topic

3\. Click topic and verify subscription shows Confirmed



\---



\### 6. SNS Email Subscription

\*\*Resource:\*\* aws\_sns\_topic\_subscription

\*\*Purpose:\*\* Delivers alert emails to configured address



Important:

\- After terraform apply check your email immediately

\- Click Confirm subscription in the AWS email

\- Without confirmation alerts will not be delivered



\---



\### 7. CloudWatch Alarm

\*\*Resource:\*\* aws\_cloudwatch\_metric\_alarm

\*\*Name:\*\* soc-lab-guardduty-findings

\*\*Purpose:\*\* Triggers SNS alert when GuardDuty detects findings



Configuration:

\- Monitors GuardDuty FindingCount metric

\- Triggers when count is greater than 0

\- Evaluation period of 5 minutes

\- Sends alert to SNS topic



Verify in console:

1\. Go to AWS Console → CloudWatch → Alarms

2\. Look for soc-lab-guardduty-findings

3\. Confirm alarm is in OK or Insufficient Data state



\---



\### 8. CloudWatch Log Group

\*\*Resource:\*\* aws\_cloudwatch\_log\_group

\*\*Name:\*\* /aws/soc-lab/soc-lab

\*\*Purpose:\*\* Centralized log storage for the lab



Configuration:

\- Log retention set to 7 days

\- Tagged for easy identification



Verify in console:

1\. Go to AWS Console → CloudWatch → Log Groups

2\. Look for /aws/soc-lab/soc-lab



\---



\## Terraform Outputs

After successful deployment run:



```cmd

terraform output

```



Expected outputs:

cloudtrail\_arn         = "arn:aws:cloudtrail:us-east-2:..."

cloudtrail\_s3\_bucket   = "soc-lab-cloudtrail-logs-..."

cloudwatch\_alarm\_name  = "soc-lab-guardduty-findings"

cloudwatch\_log\_group   = "/aws/soc-lab/soc-lab"

guardduty\_detector\_id  = "..."

sns\_topic\_arn          = "arn:aws:sns:us-east-2:..."



\## How Alerting Works

GuardDuty detects threat

↓

CloudWatch monitors FindingCount metric

↓

FindingCount exceeds 0

↓

CloudWatch Alarm triggers

↓

SNS Topic receives notification

↓

Email sent to configured address



\## Destroying the Lab

When finished run:



```cmd

terraform destroy

```



Type yes when prompted. This removes all resources and stops

any potential charges. GuardDuty charges after the 30-day

free trial so always destroy when not in use.



\## Screenshots

!\[GuardDuty Active](../screenshots/05-guardduty-active.png)

!\[CloudTrail Active](../screenshots/06-cloudtrail-active.png)

!\[S3 Bucket](../screenshots/07-s3-bucket.png)

!\[SNS Topic](../screenshots/08-sns-topic.png)

!\[CloudWatch Alarm](../screenshots/09-cloudwatch-alarm.png)

