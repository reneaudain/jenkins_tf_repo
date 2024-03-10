# Jenkins Server and S3 Artifact Storage on AWS using Terraform

This repository contains Terraform configurations for deploying a Jenkins server on an AWS EC2 instance and setting up an S3 bucket for storing build artifacts. This tutorial demonstrates how to automate infrastructure management using Terraform and integrate it with version control using GitHub.

## Prerequisites

Before you begin, ensure you have the following:

- An AWS account with appropriate permissions to create EC2 instances, S3 buckets, IAM roles, and policies.
- Terraform installed on your local machine. [Download Terraform](https://www.terraform.io/downloads.html)
- Git installed for version control. [Install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- An SSH key pair for AWS. [AWS SSH Key Pair Documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)

## Quick Start

1. **Clone the repository**

   ```bash
   git clone [https://github.com/reneaudain/jenkins_tf_repo.git]
   cd jenkins_tf_repo
   ```

2. **Initialize Terraform**

   Initialize your Terraform workspace, which will download the provider and initialize it with the settings configured in the `terraform` block.

   ```bash
   terraform init
   ```

3. **Create a `terraform.tfvars` file (optional)**
   ```bash
   To customize your deployment, you can create a `terraform.tfvars` file to override default variable values. For example:
    
    variable "account_id" {
      type = string
      default = "your_account_id"
    }
    variable "bucket_name" {
      type = string
      default = "your_bucket_name"
    }
    variable "aws_linux_ami" {
      type = string
      default = "aws_ami_for_your_region"
    }
    variable "key-pair-name" {}
    
    variable "my_ip" {
      type = string
      default = ["your.i.p.address"]
    }
    ```
4. **Apply the Terraform configuration**

   Review the plan and apply the configuration to start the deployment.

   ```bash
   terraform plan
   terraform apply
   ```

5. **Access your Jenkins server**

   Once the deployment is complete, Terraform will output the public IP of the EC2 instance. Access Jenkins by navigating to `http://<EC2-IP-ADDRESS>:8080`.

## Folder Structure

- `main.tf` - The primary Terraform configuration file for AWS resources.
- `providers.tf` - Terraform provider configuration.
- `variables.tf` - Variable definitions for the Terraform configurations.
- `outputs.tf` - Outputs after Terraform execution.
- `.gitignore` - Specifies intentionally untracked files to ignore.

## Security

This tutorial sets up a Jenkins server and S3 bucket with basic settings. For production environments, consider the following security enhancements:

- Tighten security group rules.
- Use IAM roles and policies to control access to AWS resources securely.
- Regularly update your Jenkins server and plugins to the latest versions.

## Contributing

Contributions to this project are welcome! Please fork the repository and submit a pull request with your enhancements.
