resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = merge (
    var.vpc_tags ,
    local.common_tags,{
        Name ="${local.common_name}-vpc"
    }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge (
    var.IGW_tags ,
    local.common_tags,{
        Name ="${local.common_name}-IGW"
    }
  )
}

resource "aws_subnet" "public_subnet" {
  count = length(var.pubsub_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.pubsub_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone =  local.az_names[count.index]
  tags =  merge (
    var.pubsub_tags ,
    local.common_tags,{
        Name ="${local.common_name}-public-${split("-",local.az_names[count.index])[2]})"
    }
  )
}

resource "aws_subnet" "private_subnet" {
  count = length(var.privatesub_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.privatesub_cidr[count.index]
  #map_public_ip_on_launch = true
  availability_zone =  local.az_names[count.index]
  tags =  merge (
    var.privatesub_tags ,
    local.common_tags,{
        Name ="${local.common_name}-private-${split("-",local.az_names[count.index])[2]})"
    }
  )
}

resource "aws_subnet" "database_subnet" {
  count = length(var.datasub_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.datasub_cidr[count.index]
  #map_public_ip_on_launch = true
  availability_zone =  local.az_names[count.index]
  tags =  merge (
    var.datasub_tags ,
    local.common_tags,{
        Name ="${local.common_name}-data-${split("-",local.az_names[count.index])[2]})"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id


  tags = merge (
    var.public_routetble_tags,
    local.common_tags,{
        Name ="${local.common_name}-public"
    }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id


  tags = merge (
    var.private_routetble_tags,
    local.common_tags,{
        Name ="${local.common_name}-private"
    }
  )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id


  tags = merge (
    var.database_routetble_tags,
    local.common_tags,{
        Name ="${local.common_name}-database"
    }
  )
}

resource "aws_route_table_association" "public_subnet" {
  count = length(var.pubsub_cidr)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_subnet" {
  count = length(var.privatesub_cidr)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database_subnet" {
  count = length(var.datasub_cidr)
  subnet_id      = aws_subnet.databse_subnet[count.index].id
  route_table_id = aws_route_table.database.id
}

resource "aws_eip" "nat" {
    domain   = "vpc"
    tags = merge (
    var.eip_tags,
    local.common_tags,
    {
        Name = "${local.common_name}-nat" # roboshop-dev-nat
    }
  )
}


resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "NAT_GW"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
  }

  resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
  }

  resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
  }