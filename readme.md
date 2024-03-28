# Introduction

Welcome to the lab! In this lab, you will demonstrate how to set up a small EKS cluster and deploy two NGINX nodes using Terraform. As an admin, you have been asked to deploy a simple EKS cluster running to NGINX nodes to test out a new web application. You will need to first use Terraform to deploy the EKS cluster, and then deploy the NGINX nodes with Terraform. Once confirmed they are working, you will then delete your cluster with Terraform.

## Table of Contents
- [LoginToServer](#loginToServer)
- [ConfigureAWS](#configureAWS)
- [ReviewTFs](#reviewTFs)
- [DeployEKSCluster](#deployEKSCluster)
- [DeployApplications](#deployApplications)
- [VerifyWithKubectl](#verifyWithKubectl)


## LoginToServer

ssh cloud_user@<PUBLIC_IP_ADDRESS>
Note: The AWS Access Key and AWS Secret Access Key needed to configure the AWS CLI in the terminal are provided with the lab credentials.

## ConfigureAWS

Configure the AWS CLI
Configure the AWS CLI in the Terminal
Configure your AWS CLI:

aws configure
When prompted for your AWS Access Key ID, copy and paste in the Access Key provided with the lab credentials.

When prompted for your AWS Secret Access Key, copy and paste in the Secret Access Key provided with the lab credentials.

Press Enter to accept the default region.

Press Enter to accept the default output.

## ReviewTFs

Review the Contents of the Configuration Files in the lab-terraform-eks Directory
View the contents of the directory:

ls
Go into the lab-terraform-eks-2 directory:

cd lab-terraform-eks-2/
View the contents of the lab-terraform-eks-2 directory:

ls
Open the terraform.tf file:

vim terraform.tf
Review the contents of the file, and then enter :q! to exit the file.

Open the main.tf file:

vim main.tf
Review the contents of the file, and then enter :q! to exit the file.

Open the variables.tf file:

vim variables.tf
Review the contents of the file, and then enter :q! to exit the file.

Open the outputs.tf file:

vim outputs.tf
Review the contents of the file, and then enter :q! to exit the file.

## DeployEKSCluster

Deploy the EKS Cluster
Initialize the working directory:

terraform init
Review the actions that will be performed and check for any potential errors:

terraform plan
Apply the configuration and deploy your cluster:

terraform apply
Type "yes" and hit Enter to confirm. Allow the configuration to complete successfully and create your resources, including the EKS cluster.

Configure kubectl to interact with the cluster:

aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
Confirm that kubectl was configured properly and that the cluster was successfully deployed:

kubectl get cs
The all the components should be up and running with a status of Healthy.

## DeployApplications

Deploy the NGINX Pods
Download the nginx.tf file that contains the configuration for the NGINX deployments from the GitHub repo:

wget https://raw.githubusercontent.com/ACloudGuru-Resources/content-terraform-2021/main/nginx.tf
Confirm that the file was downloaded to the directory successfully:

ls
Open the nginx.tf file:

vim nginx.tf
Review the contents of the file, and then enter :q! to exit the file.

Review the actions that will be performed and check for any potential errors:

terraform plan
Apply the configuration and deploy your NGINX pods to your EKS cluster:

terraform apply
Type "yes" and hit Enter to confirm. Allow the configuration to complete successfully and create your resources, including the NGINX pods.

Confirm that the NGINX pods were successfully deployed:

## VerifyWithKubectl

kubectl get deployments
The two long-live-the-bat pods should both be up and running.

Destroy Your Cluster
Before you destroy the infrastructure, view the resources Terraform is managing:

terraform state list
Destroy all of the resources you just created:

terraform destroy
Type "yes" and hit Enter to confirm.

Confirm the resources were all destroyed:

terraform state list
Nothing should be returned, confirming that all resources were properly destroyed.