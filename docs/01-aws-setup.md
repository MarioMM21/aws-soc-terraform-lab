\# 01 — AWS Setup



\## Overview

This document covers the AWS account setup and IAM configuration

required to deploy the SOC automation lab using Terraform.



\## Prerequisites

\- AWS account (free tier)

\- Valid credit/debit card for account verification

\- Email address for SNS alert notifications



\## Step 1 — Create AWS Account

1\. Go to aws.amazon.com

2\. Click Create a Free Account

3\. Enter your email and choose a root account password

4\. Enter payment information — free tier will not charge you

5\. Complete phone verification

6\. Select Basic Support plan (free)

7\. Wait for account activation email



\## Step 2 — Set Your Region

1\. Log into the AWS Management Console

2\. Click the region selector in the top right corner

3\. Select US East (Ohio) — us-east-2

4\. All resources will be deployed in this region



\## Step 3 — Enable GuardDuty

GuardDuty requires manual activation on new accounts:

1\. Search for GuardDuty in the AWS console search bar

2\. Click GuardDuty

3\. Click Get Started

4\. Click Enable GuardDuty

5\. This activates the 30-day free trial automatically



\## Step 4 — Create IAM User for Terraform

Never use your root account for Terraform. Create a dedicated IAM user:



1\. Search for IAM in the AWS console search bar

2\. Click Users in the left sidebar

3\. Click Create user

4\. Username: terraform-lab

5\. Click Next

6\. Select Attach policies directly

7\. Search for and check AdministratorAccess

8\. Click Next → Create user



\## Step 5 — Generate Access Keys

1\. Click on the terraform-lab user

2\. Click the Security credentials tab

3\. Scroll down to Access keys

4\. Click Create access key

5\. Select Command Line Interface (CLI)

6\. Check the confirmation box

7\. Click Next → Create access key

8\. Copy both keys immediately:

&#x20;  - Access key ID

&#x20;  - Secret access key



\## Important Security Notes

\- Never share your access keys publicly

\- Never paste access keys into chat windows or emails

\- Never commit access keys to GitHub

\- Rotate keys regularly

\- Delete keys that are no longer needed

\- Use least privilege — only grant permissions actually needed



\## Step 6 — Install AWS CLI

1\. Go to aws.amazon.com/cli

2\. Download the Windows installer

3\. Run with all defaults

4\. Verify installation:

```cmd

aws --version

```



\## Step 7 — Configure AWS CLI

```cmd

aws configure

```



Enter when prompted:

AWS Access Key ID: your access key ID

AWS Secret Access Key: your secret access key

Default region name: us-east-2

Default output format: json



\## Step 8 — Verify Connection

```cmd

aws sts get-caller-identity

```



Expected output:

```json

{

&#x20;   "UserId": "XXXXXXXXXXXXXXXXXXXX",

&#x20;   "Account": "your-account-id",

&#x20;   "Arn": "arn:aws:iam::your-account-id:user/terraform-lab"

}

```



\## Screenshots

!\[IAM Access Keys](../screenshots/01-iam-access-keys.png)

!\[GuardDuty Enabled](../screenshots/03-guardduty-enabled.png)

