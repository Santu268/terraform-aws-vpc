output "azinfo" {
  value = data.aws_availability_zones.available.names
}

output "default_vpc_cidr" {
  value       = data.aws_vpc.default.cidr_block
  description = "The primary IPv4 CIDR block of the default VPC."
}

output "default_route_table_id" {
  value = data.aws_route_table.default_vpc_route_table.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "database_subnet_ids" {
  value = aws_subnet.database_subnet[*].id
}