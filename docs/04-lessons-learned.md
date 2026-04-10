\# 04 — Lessons Learned



\## Overview

This document covers the challenges encountered during the deployment

of the AWS SOC automation lab with Terraform and how they were resolved.



\## Challenge 1 — AWS Account Suspended

\### Problem

Existing AWS account was suspended due to an outstanding balance.

Login returned an authentication error preventing access to the console.



\### Resolution

Created a fresh AWS free tier account with a new email address.

Free tier provides 12 months of limited access to AWS services

at no charge as long as usage stays within free tier limits.



\### Lesson

Always monitor your AWS billing dashboard. Set a billing alarm

immediately after creating an account to alert you if charges

exceed a threshold. Go to CloudWatch → Alarms → Create alarm

and select Billing as the metric.



\---



\## Challenge 2 — Exposed AWS Access Keys

\### Problem

During aws configure setup the access key ID and secret access key

were accidentally pasted directly into the terminal making them

visible in the session output.



\### Resolution

1\. Immediately went to IAM → Users → terraform-lab

2\. Deactivated and deleted the exposed access keys

3\. Generated new access keys

4\. Ran aws configure again with the new keys

5\. Verified connection with aws sts get-caller-identity



\### Lesson

Never paste access keys directly into a terminal or chat window.

Always run aws configure first and wait for the prompts before

entering credentials. The prompts hide your input for security.

If keys are ever exposed treat them as compromised and rotate

them immediately.



\---



\## Challenge 3 — GuardDuty Subscription Error

\### Problem

Running terraform apply returned:

Error: creating GuardDuty Detector: operation error GuardDuty:

CreateDetector, StatusCode: 403, SubscriptionRequiredException



\### Root Cause

New AWS accounts require GuardDuty to be manually activated

in the console before Terraform can manage it via the API.



\### Resolution

1\. Went to AWS Console → GuardDuty

2\. Clicked Get Started → Enable GuardDuty

3\. This activated the 30-day free trial

4\. Ran terraform apply again successfully



\### Lesson

Some AWS services require manual console activation before they

can be provisioned via Terraform or the API. Always check the

AWS console first if you get a SubscriptionRequiredException error.



\---



\## Challenge 4 — Terraform Provider File Too Large for GitHub

\### Problem

Running git push returned:

remote: error: File .terraform/providers/.../terraform-provider-aws.exe

is 685.52 MB; this exceeds GitHub's file size limit of 100.00 MB



\### Root Cause

The Terraform AWS provider binary was being tracked by git.

This file is downloaded by terraform init and should never

be committed to version control.



\### Resolution

Created a .gitignore file excluding the .terraform directory:

.terraform/

terraform.tfstate

terraform.tfstate.backup

\*.tfvars



Then removed the file from git history:

```cmd

git filter-branch --force --index-filter "git rm --cached \\

\--ignore-unmatch .terraform/providers/.../terraform-provider-aws.exe" \\

\--prune-empty --tag-name-filter cat -- --all

git push origin main --force

```



\### Lesson

Always create a .gitignore file before running terraform init.

The .terraform directory, tfstate files, and tfvars files should

never be committed to GitHub. Use the standard Terraform gitignore

template at gitignore.io when starting a new project.



\---



\## Challenge 5 — tfstate and tfvars Files Pushed to GitHub

\### Problem

terraform.tfstate and terraform.tfvars files were accidentally

pushed to GitHub. These files contain sensitive information

including AWS account IDs and resource ARNs.



\### Resolution

```cmd

git rm --cached terraform.tfstate

git rm --cached terraform.tfstate.backup

git rm --cached terraform.tfvars

git commit -m "Remove sensitive files"

git push origin main

```



\### Lesson

The tfstate file is Terraform's source of truth for your

infrastructure. It contains sensitive resource details that

should never be public. Always add these to .gitignore before

your first commit. Consider using Terraform Cloud or an S3

backend with encryption for remote state storage in production.



\---



\## Challenge 6 — Windows Saving Files as .txt Instead of .tf

\### Problem

When saving Terraform files in Notepad the files were saved

with a .txt extension instead of .tf making them invisible

to Terraform.



\### Resolution

Used CMD to rename the files:

```cmd

del main.tf

ren main.tf.txt main.tf

```



Then re-ran terraform init to reinitialize with the correct files.



\### Lesson

When saving files in Notepad always set Save as type to

All Files before saving. This prevents Windows from

automatically appending .txt to the filename. Alternatively

use a code editor like VS Code which handles file extensions

correctly by default.



\---



\## Challenge 7 — Wrong AWS Region in Console

\### Problem

After deploying resources with Terraform the resources did not

appear in the AWS console.



\### Root Cause

The AWS console was showing a different region than where

Terraform deployed the resources. Terraform deployed to

us-east-2 but the console was showing us-east-1.



\### Resolution

Clicked the region selector in the top right of the AWS console

and switched to US East (Ohio) — us-east-2. All resources

appeared immediately.



\### Lesson

Always verify your region in the AWS console matches the region

in your Terraform configuration. This is one of the most common

sources of confusion in AWS — resources are region-specific and

will not appear if you are looking in the wrong region.



\---



\## Key Takeaways



\### Technical Skills Gained

\- Terraform Infrastructure as Code on AWS

\- AWS IAM user and access key management

\- GuardDuty threat detection configuration

\- CloudTrail API activity logging

\- S3 bucket policy configuration

\- CloudWatch alarm and metric configuration

\- SNS topic and email subscription setup

\- Git version control for infrastructure code

\- Security best practices for credential management



\### Security Concepts Demonstrated

\- Infrastructure as Code for repeatable secure deployments

\- Principle of least privilege with dedicated IAM user

\- Automated threat detection with GuardDuty

\- API audit logging with CloudTrail

\- Real time alerting pipeline — GuardDuty to CloudWatch to SNS

\- Sensitive file exclusion from version control



\### What I Would Do Differently

\- Create .gitignore before running terraform init

\- Use VS Code instead of Notepad for editing Terraform files

\- Set up a billing alarm immediately after account creation

\- Use remote state storage in S3 instead of local tfstate

\- Never use AdministratorAccess for Terraform in production

&#x20; — create a custom policy with only required permissions

