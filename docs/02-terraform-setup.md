\# 02 — Terraform Setup



\## Overview

This document covers the installation and configuration of Terraform

on a Windows host machine to deploy the AWS SOC automation lab.



\## Prerequisites

\- Windows 10/11 host machine

\- AWS CLI installed and configured

\- GitHub account



\## Step 1 — Download Terraform

1\. Go to developer.hashicorp.com/terraform/install

2\. Select Windows

3\. Download the AMD64 zip file

4\. Extract the zip file to a folder on your machine

&#x20;  - Example: C:\\Users\\mm\\OneDrive\\Desktop\\terraform\_1.14.8\_windows\_amd64



\## Step 2 — Add Terraform to PATH

1\. Press Windows Key and search Environment Variables

2\. Click Edit the system environment variables

3\. Click Environment Variables at the bottom

4\. Under System Variables find Path and double click it

5\. Click New

6\. Paste the full path to your terraform folder

&#x20;  - Example: C:\\Users\\mm\\OneDrive\\Desktop\\terraform\_1.14.8\_windows\_amd64

7\. Click OK → OK → OK



\## Step 3 — Verify Installation

Open a new CMD window and run:



```cmd

terraform --version

```



Expected output:

Terraform v1.14.8



\## Step 4 — Clone the Repository

```cmd

cd "C:\\Users\\mm\\OneDrive\\Desktop"

git clone https://github.com/MarioMM21/aws-soc-terraform-lab.git

cd aws-soc-terraform-lab

```



\## Step 5 — Create terraform.tfvars

Create a file named terraform.tfvars in the project root:



```hcl

aws\_region   = "us-east-2"

project\_name = "soc-lab"

account\_id   = "YOUR\_AWS\_ACCOUNT\_ID"

alert\_email  = "YOUR\_EMAIL@example.com"

```



Replace the values with your actual AWS account ID and email address.



Note: This file is excluded from version control via .gitignore

because it contains sensitive account information.



\## Step 6 — Initialize Terraform

```cmd

terraform init

```



This downloads the AWS provider plugin and sets up the backend.

Expected output:

Terraform has been successfully initialized!



\## Step 7 — Preview the Deployment

```cmd

terraform plan

```



Expected output at the bottom:

Plan: 8 to add, 0 to change, 0 to destroy.



\## Step 8 — Deploy the Lab

```cmd

terraform apply

```



Type yes when prompted:

Do you want to perform these actions?

Terraform will perform the actions described above.

Only 'yes' will be accepted to approve.

Enter a value: yes



\## Step 9 — Confirm SNS Subscription

After deployment check your email for a message from AWS SNS.

Click Confirm subscription to activate email alerting.



\## Terraform File Structure

aws-soc-terraform-lab/

├── main.tf              ← All AWS resources defined here

├── variables.tf         ← Variable definitions

├── outputs.tf           ← Output values after deployment

├── terraform.tfvars     ← Your specific values (not in GitHub)

├── .gitignore           ← Excludes sensitive files from GitHub

├── .terraform.lock.hcl  ← Provider version lock file

├── docs/                ← Documentation files

└── screenshots/         ← Lab screenshots

