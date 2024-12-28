output "subnet_id" {
    value = aws_subnet.my_aws_subnet.id
}

output "default_security_group_id" {
    value = aws_default_security_group.my_aws_default_security_group.id
} 