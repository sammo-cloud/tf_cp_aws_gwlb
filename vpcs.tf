################################################
#### Geo-Cluster Transit VPC
################################################
resource "aws_vpc" "vpc_spoke" {
    cidr_block           = var.vpc_spoke_cidr
    enable_dns_hostnames = true
    enable_dns_support   = true
    instance_tenancy     = "default"

    tags = {
        "Name" = "Spoke VPC"
    }
}

resource "aws_subnet" "sn_spoke_public_a" {
    vpc_id                  = aws_vpc.vpc_spoke.id
    cidr_block              = cidrsubnet(var.vpc_spoke_cidr, 8, 1)
    availability_zone       = "${var.aws_region}a"
    map_public_ip_on_launch = true

    tags = {
        "Name" = "Spoke Public subnet 1"
        "Network" = "Public"
    }
}

resource "aws_subnet" "sn_spoke_private_a" {
    vpc_id                  = aws_vpc.vpc_spoke.id
    cidr_block              = cidrsubnet(var.vpc_spoke_cidr, 8, 11)
    availability_zone       = "${var.aws_region}a"
    map_public_ip_on_launch = false

    tags = {
        "Network" = "Private"
        "Name" = "Spoke Private subnet 1"
    }
}

resource "aws_subnet" "sn_spoke_tgwha_a" {
    vpc_id                  = aws_vpc.vpc_spoke.id
    cidr_block              = cidrsubnet(var.vpc_spoke_cidr, 8, 201)
    availability_zone       = "${var.aws_region}a"
    map_public_ip_on_launch = false

    tags = {
        "Network" = "Private"
        "Name" = "Spoke TGW HA subnet 1"
    }
}

resource "aws_subnet" "sn_spoke_tgwha_b" {
    vpc_id                  = aws_vpc.vpc_spoke.id
    cidr_block              = cidrsubnet(var.vpc_spoke_cidr, 8, 202)
    availability_zone       = "${var.aws_region}b"
    map_public_ip_on_launch = false

    tags = {
        "Name" = "Spoke TGW HA subnet 2"
        "Network" = "Private"
    }
}

resource "aws_subnet" "sn_spoke_public_b" {
    vpc_id                  = aws_vpc.vpc_spoke.id
    cidr_block              = cidrsubnet(var.vpc_spoke_cidr, 8, 2)
    availability_zone       = "${var.aws_region}b"
    map_public_ip_on_launch = true

    tags = {
        "Network" = "Public"
        "Name" = "Spoke Public subnet 2"
    }
}

resource "aws_subnet" "sn_spoke_private_b" {
    vpc_id                  = aws_vpc.vpc_spoke.id
    cidr_block              = cidrsubnet(var.vpc_spoke_cidr, 8, 12)
    availability_zone       = "${var.aws_region}b"
    map_public_ip_on_launch = false

    tags = {
        "Network" = "Private"
        "Name" = "Spoke Private subnet 2"
    }
}

resource "aws_internet_gateway" "igw_spoke" {
    vpc_id     = aws_vpc.vpc_spoke.id

    tags = {
        "Network" = "Public"
        "Name" = "Spoke IGW"
    }
}

resource "aws_route_table" "rt_spoke_public" {
    vpc_id     = aws_vpc.vpc_spoke.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_spoke.id
    }

    tags = {
        "Name" = "Spoke Public Subnets"
        "Network" = "Public"
    }
}

resource "aws_route_table" "rt_spoke_private" {
    vpc_id     = aws_vpc.vpc_spoke.id

    tags = {
        "Name" = "Spoke Private Subnets"
    }
}

resource "aws_route_table_association" "rta_spoke_public_a" {
    route_table_id = aws_route_table.rt_spoke_public.id
    subnet_id = aws_subnet.sn_spoke_public_a.id
}

resource "aws_route_table_association" "rta_spoke_public_b" {
    route_table_id = aws_route_table.rt_spoke_public.id
    subnet_id = aws_subnet.sn_spoke_public_b.id
}
