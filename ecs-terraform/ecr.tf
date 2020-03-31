
data "aws_ecr_repository" "nginx" {
    name = "nginx-ecs-terraform"
}

data "aws_ecr_repository" "app" {
    name = "app"
}

