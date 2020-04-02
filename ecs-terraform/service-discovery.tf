
// Comment-out this whole file to disable Service Discovery

resource "aws_service_discovery_private_dns_namespace" "simple-stack" {
  name        = "local"
  description = "simple-stack-nginx"
  vpc         = aws_vpc.main.id
}


resource "aws_service_discovery_service" "simple-stack-nginx" {
  name = "nginx"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.simple-stack.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}


resource "aws_service_discovery_service" "simple-stack-app" {
  name = "app"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.simple-stack.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

