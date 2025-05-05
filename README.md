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

## ArgoCD installation Steps

- Use the below bash command to install the application

```bash
kubectl create namespace argocd  | Used to create namespace 
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml | Used to install argocd application
```

- Access the application using the port-forwarding command below

```bash
kubectl port-forward service/argocd-server -n argocd 8082:443  | Used to start the service, accessed on localhost:8082
```

- To use a load balancer type of service

```bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'    | For Ubuntu This would provision a load balancer on argocd to run its service. 
kubectl patch svc argocd-server -n argocd -p "{\"spec\": {\"type\": \"LoadBalancer\"}}" -n argocd | For windows command prompt This would provision a load balancer on argocd to run its service
```

- Used the IP to access the application if using a load balancer. Log on would be admin which is default username and password would be generated using script below

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode  | Via Ubuntu 

argocd admin initial password -n argocd  | via ubuntu were argocd cli is in use 

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) } | Windows powershell
```

## Steps to Installing Ingress controller

### Ingress service/resource

- An Ingress is an API object in Kubernetes that manages external access to services within the cluster.

- It provides a way to route external traffic to different services based on the host, path, or other rules.

- Ingress resources are typically used to manage HTTP and HTTPS traffic, making them a crucial component for exposing web applications and microservices to the internet.

- First create a namespace for the service

```bash
kubectl create ns ingress-nginx   | To create name space ingress-nginx
```

- Install the Ingress Controllers next using helm package manager for k8s

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm search repo ingress-nginx           | Used to search for the added repo would output the details of your repo.

helm install pumej-nginx-com ingress-nginx/ingress-nginx -n ingress-nginx   | Would install your helm repo as pumej-nginx
helm ls -n ingress-nginx     | Used to confirm your install, would list your helm

kubectl get svc -n ingress-nginx         | This would give the services and the external IP address to run your application on.
```

- This would generate an external IP as it provisions a load balance using the ingress controller. Sample output

NAME                                                 TYPE           CLUSTER-IP      EXTERNAL-IP       PORT(S)                      AGE
pumej-nginx-com-ingress-nginx-controller             LoadBalancer   10.245.216.49   143.244.199.159   80:30323/TCP,443:31884/TCP   3m54s
pumej-nginx-com-ingress-nginx-controller-admission   ClusterIP      10.245.55.39    None              443/TCP                      3m54s

## Steps to Configure domain to point to Ingress load balancer IP address

- Ensure your domain registra is confiured to AWS or Digital Ocean name servers
- Create a sub domain name for your site eg amazon.pumej.com
- Then point it to the Ingress controller external ip address and click on create record
- You would get output A- record created successfully
- Now we need to edit/update the ingress.yml and issuer.yml files for the ingress utility to function. After this step apply the files accordingly

```bash
kubectl apply -f ingress.yml -n default        | Used to apply the ingress the f flag used to specify or point to the file been applied.
```

- Now you should be able to access your website using your host name amazon.pumej.com, however the site isn't secured, we need to make it secure live.

## Steps to applying Certificate measures to the application

- Download and inatall latest cert manager from artifactory hub repo
- <https://artifacthub.io/packages/helm/cert-manager/cert-manager>   | Instructions site

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.1/cert-manager.crds.yaml      | Used to apply the chart - download all its dependencies   
kubectl get crds                                                                         | Would give you a list of the crds added
```

- Add the helm repo for issuing certs jetstack

```bash
helm repo add jetstack https://charts.jetstack.io --force-update
```

- Install the helm chart for the cert manager

```bash
helm repo update jetstack
kubectl create ns cert-manager
helm install cert-manager --namespace cert-manager --version v1.17.2 jetstack/cert-manager

helm delete cert-manager --namespace cert-manager           | Used to uninstall the chart
kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/v1.17.2/cert-manager.crds.yaml
```

- Now we have to update the issuer.yml file to use the cert manager correctly.
- The issuer is responsible for fetching the TLS for NGINX and a typical file looks like the below
- Now we can apply the issuer file using kubectl apply command with the f flag

```bash
kubectl apply -f issuer.yml                 | Applied to namespace where app was deployed
kubectl get certificate                     | Used to get the certificate, should return true 
```

- You can check your website again | Should show your connection as secured
