
output "ManagementIP" {
  value = aws_eip.pan1mgmtip.public_ip
}

output "PublicIP" {
  value = aws_eip.pan1pubip.public_ip
}

