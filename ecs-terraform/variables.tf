variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-west-2"
}

variable "aws_profile" {
    description = "The AWS profile to use"
    default     = "notes-app"
}

variable "ecs_service_name" {
    default = "simple-app"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = 2
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "myEcsTaskExecutionRole"
}

variable "ecs_auto_scale_role_name" {
  description = "ECS auto scale role Name"
  default = "myEcsAutoScaleRole"
}

variable "nginx_image" {
  description = "NGINX image to run in the ECS cluster"
  default     = "098106984154.dkr.ecr.us-west-2.amazonaws.com/nginx-ecs-terraform"
}

variable "nginx_port" {
  description = "Port exposed by the NGINX docker image"
  default     = 80
}

variable "nginx_count" {
  description = "Number of NGINX containers to run"
  default     = 1
}

variable "nginx_fargate_cpu" {
  description = "Fargate instance CPU units to provision for NGINX (1 vCPU = 1024 CPU units)"
  default     = 256
}

variable "nginx_fargate_memory" {
  description = "Fargate instance memory to provision for NGINX (in MiB)"
  default     = 512
}

variable "app_image" {
  description = "Back-end application image to run in the ECS cluster"
  default     = "098106984154.dkr.ecr.us-west-2.amazonaws.com/app"
}

variable "app_port" {
  description = "Port exposed by the app docker image"
  default     = 3000
}

variable "app_count" {
  description = "Number of back-end application containers to run"
  default     = 2
}

variable "app_fargate_cpu" {
  description = "Fargate instance CPU units to provision for back-end application (1 vCPU = 1024 CPU units)"
  default     = 256
}

variable "app_fargate_memory" {
  description = "Fargate instance memory to provision for back-end application (in MiB)"
  default     = 512
}
