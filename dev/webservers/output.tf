output "public_ips" {
  value = aws_instance.pub_ec2[*].public_ip
}

output "webserver_ids" {
  value = aws_instance.pub_ec2[*].id
}