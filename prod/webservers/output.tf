output "private_ips" {
  value = aws_instance.private_vm[*].private_ip
}
