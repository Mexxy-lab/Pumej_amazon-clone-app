# Define the provider for AWS
provider "aws" {
  region = "ap-south-1"
}

# Create an ECS cluster
resource "aws_ecs_cluster" "pumej_cluster" {
  name = "amazon-ecs-cluster"
}

# Create a task definition
resource "aws_ecs_task_definition" "my_task_definition" {
  family                   = "my-task-family-test"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = <<EOF
[
  {
    "name": "pumej-container",
    "image": "598189530267.dkr.ecr.ap-south-1.amazonaws.com/pumejrepo:v1.0",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
EOF
}

# Create a service to run the task on the cluster
resource "aws_ecs_service" "my_service" {
  name            = "amazon-service"
  cluster         = aws_ecs_cluster.pumej_cluster.id
  task_definition = aws_ecs_task_definition.my_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = ["subnet-0f3c3846f9c0551b6"]
    security_groups  = ["sg-08849123726c14ea7"]
    assign_public_ip = true
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecs_task_execution_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution_role.name
}

# Digital Ocean Cloud Infrastructure set up 

# Define the provider for DigitalOcean
# provider "digitalocean" {
#   token = var.do_token
# }

# variable "do_token" {}

# variable "region" {
#   default = "sgp1" # Singapore; change as needed
# }

# variable "cluster_name" {
#   default = "pumej-k8s-cluster"
# }

# # Create a Kubernetes cluster on DigitalOcean
# resource "digitalocean_kubernetes_cluster" "pumej_cluster" {
#   name    = var.cluster_name
#   region  = var.region
#   version = "1.29.1-do.0" # Check latest version

#   node_pool {
#     name       = "pumej-node-pool"
#     size       = "s-2vcpu-4gb"
#     node_count = 1
#   }
# }

# # Create a namespace (optional)
# resource "kubernetes_namespace" "pumej" {
#   metadata {
#     name = "pumej"
#   }
# }

# # Deploy your container using Kubernetes Deployment
# resource "kubernetes_deployment" "pumej_app" {
#   metadata {
#     name      = "pumej-app"
#     namespace = kubernetes_namespace.pumej.metadata[0].name
#     labels = {
#       app = "pumej"
#     }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#         app = "pumej"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "pumej"
#         }
#       }

#       spec {
#         container {
#           image = "pumejlab/amazon:v1.0"
#           name  = "pumej-container"

#           port {
#             container_port = 3000
#           }
#         }
#       }
#     }
#   }
# }

# # Expose the deployment via a LoadBalancer service
# resource "kubernetes_service" "pumej_service" {
#   metadata {
#     name      = "pumej-service"
#     namespace = kubernetes_namespace.pumej.metadata[0].name
#   }

#   spec {
#     selector = {
#       app = kubernetes_deployment.pumej_app.metadata[0].labels.app
#     }

#     port {
#       port        = 80
#       target_port = 3000
#     }

#     type = "LoadBalancer"
#   }
# }
