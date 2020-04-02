# ecs.tf

resource "aws_ecs_cluster" "main" {
  name = "${var.ecs_service_name}-cluster"
}

resource "aws_ecs_task_definition" "nginx" {
  family                   = "${var.ecs_service_name}-nginx-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  // Uncomment this if using a single Service
  // cpu                      = var.nginx_fargate_cpu + var.app_fargate_cpu
  // memory                   = var.nginx_fargate_memory + var.app_fargate_memory
  // Comment-out the following two lines if using a single Service
  cpu                      = var.nginx_fargate_cpu
  memory                   = var.nginx_fargate_memory
  container_definitions    = jsonencode(
        [
            {
                name = "nginx"
                image = data.aws_ecr_repository.nginx.repository_url
                cpu = var.nginx_fargate_cpu
                memory = var.nginx_fargate_memory
                networkMode = "awsvpc"
                logConfiguration = {
                    logDriver = "awslogs"
                    options = {
                        awslogs-group = "/ecs/${var.ecs_service_name}-nginx"
                        awslogs-region = var.aws_region
                        awslogs-stream-prefix = "ecs"
                    }
                }
                portMappings = [ {
                    containerPort = var.nginx_port
                    hostPort = var.nginx_port
                } ]
            },
            // Uncomment this to have both applications in one Service
            /* {
                name = "app"
                image = data.aws_ecr_repository.app.repository_url
                cpu = var.app_fargate_cpu
                memory = var.app_fargate_memory
                networkMode = "awsvpc"
                logConfiguration = {
                    logDriver = "awslogs"
                    options = {
                        awslogs-group = "/ecs/${var.ecs_service_name}-app"
                        awslogs-region = var.aws_region
                        awslogs-stream-prefix = "ecs"
                    }
                }
                portMappings = [ {
                    containerPort = var.app_port
                    hostPort = var.app_port
                } ]
            } */
        ]
  )
}

resource "aws_ecs_service" "nginx" {
  name            = "${var.ecs_service_name}-nginx-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.nginx.arn
  desired_count   = var.nginx_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.nginx_task.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  // Comment this out to disable connecting to Service Discovery
  service_registries {
      registry_arn = aws_service_discovery_service.simple-stack-nginx.arn
      container_name = "nginx"
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.nginx.id
    container_name   = "nginx"
    container_port   = var.nginx_port
  }

  depends_on = [ aws_ecs_cluster.main, aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs_task_execution_role, aws_security_group.nginx_task ]
}

// Comment this out if using a single Service
resource "aws_ecs_task_definition" "app" {
  family                   = "${var.ecs_service_name}-app-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.app_fargate_cpu
  memory                   = var.app_fargate_memory
  container_definitions    = jsonencode(
        [ {
                name = "app"
                image = data.aws_ecr_repository.app.repository_url
                cpu = var.app_fargate_cpu
                memory = var.app_fargate_memory
                networkMode = "awsvpc"
                logConfiguration = {
                    logDriver = "awslogs"
                    options = {
                        awslogs-group = "/ecs/${var.ecs_service_name}-app"
                        awslogs-region = var.aws_region
                        awslogs-stream-prefix = "ecs"
                    }
                }
                portMappings = [ {
                    containerPort = var.app_port
                    hostPort = var.app_port
                } ]
        } ]
  )
}

// Comment this out if using a single Service
resource "aws_ecs_service" "app" {
  name            = "${var.ecs_service_name}-app-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.app_task.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = false
  }

  service_registries {
      registry_arn = aws_service_discovery_service.simple-stack-app.arn
      container_name = "app"
  }

  depends_on = [ aws_ecs_cluster.main, aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs_task_execution_role, aws_security_group.app_task ]
}