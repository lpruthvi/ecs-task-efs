output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.Vpc.id
}
output "public_subnet" {
  value = aws_subnet.public_subnet.*.id
}
output "private_subnet" {
  value = aws_subnet.private_subnet.*.id
}
output "rds_subnet" {
  value = aws_subnet.rds_subnet.*.id
}