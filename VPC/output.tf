output "subnet_id_A" {
    value = aws_subnet.my_aws_subnet_A.id
}

output "subnet_id_B" {
    value = aws_subnet.my_aws_subnet_B.id
}

output "default_security_group_id" {
    value = aws_default_security_group.my_aws_default_security_group.id
} 