# Provision Amazon EKS Cluster and Deploy LTE Application

This repo is a fork of [Hashicorp's learn-terraform-provision-eks-cluster repo](https://github.com/hashicorp/learn-terraform-provision-eks-cluster), containing
Terraform configuration files to provision an EKS cluster on AWS.

## Purpose
This repository exists to make it easy to provision an Amazon EKS cluster and deploy the latest version of the [LTE Application container image](hhttps://hub.docker.com/r/ethanejones/lteapplication) using Terraform.

Once applied, Terraform will have provisioned a VPC, security groups, EKS cluster, and a load balancer to serve the LTE application that it will have deployed as well. 3 EC2 instances will have been created (2 T2.small, 1 T2.medium).

>**_WARNING:_** AWS charges may apply


## Assumptions
This guide was written with the Windows operating system in mind so links to installation instructions will be directly to the Windows case when available, otherwise links will be to a generic page containing instructions for multiple operating systems.

If you will be using a Unix based system please be sure to make the following change before running Terraform.
Remove this line from eks-cluster.tf
```
wait_for_cluster_interpreter = ["C:/Program Files/Git/bin/sh.exe", "-c"]
```

## Prerequisites
Ensure you have the items below setup/installed:
- [AWS account](https://portal.aws.amazon.com/billing/signup?nc2=h_ct&src=default&redirect_url=https%3A%2F%2Faws.amazon.com%2Fregistration-confirmation#/start) with an IAM user with the IAM permissions listed on the [EKS module documentation](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/iam-permissions.md)
- [Terraform](https://www.terraform.io/downloads.html)
- Configured [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-windows.html)
  - ```
    $ aws configure
    AWS Access Key ID [None]: YOUR_AWS_ACCESS_KEY_ID
    AWS Secret Access Key [None]: YOUR_AWS_SECRET_ACCESS_KEY
    Default region name [None]: YOUR_AWS_REGION
    Default output format [None]: json
    ```
- [AWS IAM Authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html) (scroll near bottom for Windows instructions)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-windows)
- [wget](https://eternallybored.org/misc/wget/)

>**_NOTE:_** Ensure binaries are included in your PATH environment variable

## Provision EKS Cluster and Deploy LTE Application
- Clone Repository
`$ git clone https://github.com/ethanejones/provision-eks-cluster-deploy-lte-application.git`
- Change Directory
`$ cd provision-eks-cluster-deploy-lte-application`
- Initialize Terraform Workspace
`$ terraform init`
- Provision the EKS Cluster and Deploy the LTE Application
```
$ terraform apply

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

# output truncated ...

Plan: 56 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
```

## Cleanup
- Destroy Resources With Terraform
`$ terraform destroy`
