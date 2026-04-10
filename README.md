# aws-soc-terraform-lab

AWS SOC automation lab provisioned with Terraform — GuardDuty, CloudTrail, CloudWatch, SNS alerting





\## What This Lab Demonstrates



\- Infrastructure as Code using Terraform

\- AWS security service provisioning and configuration

\- Real-time threat detection with Amazon GuardDuty

\- API activity auditing with AWS CloudTrail

\- Automated email alerting via Amazon SNS

\- CloudWatch alarm triggered by GuardDuty findings

\- Secure S3 bucket policy configuration for CloudTrail

\- IAM user and access key management for Terraform



\## Resources Provisioned



| Resource | Name | Purpose |

|---|---|---|

| S3 Bucket | soc-lab-cloudtrail-logs | Stores CloudTrail audit logs |

| CloudTrail | soc-lab-trail | Logs all AWS API activity |

| GuardDuty Detector | soc-lab-guardduty | Detects threats and anomalies |

| SNS Topic | soc-lab-alerts | Sends email alerts on findings |

| CloudWatch Alarm | soc-lab-guardduty-findings | Triggers on GuardDuty findings |

| CloudWatch Log Group | /aws/soc-lab/soc-lab | Centralized log storage |



\## Prerequisites



\- AWS account (free tier)

\- Terraform v1.0 or higher

\- AWS CLI configured with valid credentials

\- IAM user with AdministratorAccess policy



\## How to Deploy



\### 1. Clone the repository

```bash

git clone https://github.com/MarioMM21/aws-soc-terraform-lab.git

cd aws-soc-terraform-lab

```



\### 2. Configure your variables

Create a `terraform.tfvars` file:

```hcl

aws\_region   = "us-east-2"

project\_name = "soc-lab"

account\_id   = "YOUR\_AWS\_ACCOUNT\_ID"

alert\_email  = "YOUR\_EMAIL@example.com"

```



\### 3. Initialize Terraform

```bash

terraform init

```



\### 4. Preview the deployment

```bash

terraform plan

```



\### 5. Deploy the lab

```bash

terraform apply

```



\### 6. Confirm SNS subscription

Check your email and click the confirmation link from AWS SNS

to activate alert notifications.



\### 7. Destroy the lab when done

```bash

terraform destroy

```



\## Terraform Outputs



After successful deployment Terraform displays:



| Output | Description |

|---|---|

| guardduty\_detector\_id | GuardDuty Detector ID |

| cloudtrail\_arn | CloudTrail ARN |

| cloudtrail\_s3\_bucket | S3 bucket storing logs |

| sns\_topic\_arn | SNS Topic ARN for alerts |

| cloudwatch\_alarm\_name | CloudWatch alarm name |

| cloudwatch\_log\_group | CloudWatch Log Group path |



\## Security Considerations



\- S3 bucket policy restricts access to CloudTrail service only

\- All resources tagged for easy identification and cost tracking

\- GuardDuty 30-day free trial included with new AWS accounts

\- Terraform state files excluded from version control via .gitignore

\- AWS credentials never hardcoded — managed via AWS CLI configuration



\## Skills Demonstrated



`Terraform` `AWS` `GuardDuty` `CloudTrail` `CloudWatch` `SNS`

`S3` `IAM` `Infrastructure as Code` `Cloud Security` `SIEM`

`Threat Detection` `Automated Alerting` `DevSecOps`



\## Lab Status



| Task | Status |

|---|---|

| Terraform configuration | ✅ Complete |

| S3 bucket and policy | ✅ Complete |

| CloudTrail logging | ✅ Complete |

| GuardDuty threat detection | ✅ Complete |

| SNS email alerting | ✅ Complete |

| CloudWatch monitoring | ✅ Complete |

| Documentation | ✅ Complete |

