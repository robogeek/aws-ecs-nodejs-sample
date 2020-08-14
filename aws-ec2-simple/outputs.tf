
output "ec2-public-arn" { value = aws_instance.public.arn }

output "ec2-public-dns" { value = aws_instance.public.public_dns }
output "ec2-public-ip"  { value = aws_instance.public.public_ip }

output "ec2-private-dns" { value = aws_instance.public.private_dns }
output "ec2-private-ip"  { value = aws_instance.public.private_ip }
