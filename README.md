# Welcome to CICD Project for NETFLIX clone app in Javascript

This is a CICD project for deploying a Amazon clone app.

</center>

![alt text](./pictures/amazon.png)

</center>

## Steps to Deploy Amazon cloned app using Terraform/AWS Fargate or AWS cluster

- This project is designed for the deployment of a Netflix clone application written in React language
- The image is built using a Dockerfile from ECR to ECS from UI and using Terraform/Jenkins for automation.
- Make sure to have your image deployed to Amazon ECR using the CI jenkins pipeline build to deploy the image. Here we used jenkinsfile for this.
- Create your ECS - Elastic container service ecs_main.tf file in our case for creating the resources (ECS) via terraform. Ensure your image ID is properly tagged in the main.tf file.
- Run through the terraform commands, fmt, init, validate, plan and apply to proovision your resources accordingly. Reference the ecs_main.tf file.

```bash
terraform fmt
terraform int
terraform validate
terraform plan
terraform apply
```

- You should be able to access the application using the public IP address of your cluster task service.

- Now we have to automate the build using Jenkins to deploy the application using terraform.
- Use the jenkinsfile in root directory to build the pipeline for automating the above process.

## Second Phase of project, Deploying the application using ArgoCD

- Using ArgoCd for the deployment

```bash
eksctl create cluster --name nameOfCluster --region ap-south-1
eksctl create cluster --name pumejcluster --region ap-south-1
```
