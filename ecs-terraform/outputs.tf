# outputs.tf

output "alb_nginx_dns_name" {
  value = aws_alb.main.dns_name
}

output "alb_nginx_arn" {
    value = aws_alb.main.arn
}

/* output "alb_app_dns_name" {
    value = aws_alb.app.dns_name
}

output "alb_app_arn" {
    value = aws_alb.app.arn
} */
