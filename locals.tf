locals {
    common_tags = {
        Project = var.project
        Env = var.env
        Name = local.common_name
        Terraform = true
    }

    common_name = "${var.project}-${var.env}" # roboshop-dev
    az_names = slice(data.aws_availability_zones.available.names,0,2) # 2 is exclusive
    default_cidr = data.aws_vpc.default.cidr_block
    my_cidr = aws_vpc.main.cidr_block
}