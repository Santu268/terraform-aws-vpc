resource "aws_vpc_peering_connection" "main" {
  count = var.is_peering_required ? 1 : 0  
  peer_vpc_id   = data.aws_vpc.default.id
  vpc_id        = aws_vpc.main.id
  auto_accept   = true
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
  requester {
    allow_remote_vpc_dns_resolution = true
  }
   tags = merge(
   var.vpc_peering_tags ,
   local.common_tags,
    {
        Name = "${local.common_name}-default"
    }
   )
}

resource "aws_route" "public_peering" {
  count = var.is_peering_required ? 1 : 0   
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = local.default_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
}

resource "aws_route" "private_peering" {
  count = var.is_peering_required ? 1 : 0   
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = local.default_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
}

resource "aws_route" "database_peering" {
  count = var.is_peering_required ? 1 : 0   
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = local.default_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
}


resource "aws_route" "default" {
  count = var.is_peering_required ? 1 : 0   
  route_table_id            = data.aws_route_table.default_vpc_route_table.id
  destination_cidr_block    = local.my_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
}