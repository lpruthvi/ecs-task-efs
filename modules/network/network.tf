# az data from AWS
data "aws_availability_zones" "available" {}

# Vpc resource
resource "aws_vpc" "Vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.network_name}_vpc"
    env = var.network_name
    provider = "Terraform"
  }
}

# Internet gateway for the public subnets
resource "aws_internet_gateway" "myInternetGateway" {
  vpc_id = aws_vpc.Vpc.id
  tags = {
    Name = "${var.network_name}_igw"
    env = var.network_name
    provider = "Terraform"
  }
}

# Subnet (public)
resource "aws_subnet" "public_subnet" {
  count                   = length(var.vpc_public_subnets)
  vpc_id                  = aws_vpc.Vpc.id
  cidr_block              = element(var.vpc_public_subnets,count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.network_name}_public-subunet_${count.index}"
    env = var.network_name
    provider = "Terraform"
  }
}

# Subnet (private)
resource "aws_subnet" "private_subnet" {
  count                   = length(var.vpc_private_subnets)
  vpc_id                  = aws_vpc.Vpc.id
  cidr_block              = element(var.vpc_private_subnets,count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.network_name}_private-subunet_${count.index}"
    env = var.network_name
    provider = "Terraform"
  }
}
# Subnet (RDS)
resource "aws_subnet" "rds_subnet" {
  count                   = length(var.vpc_rds_subnets)
  vpc_id                  = aws_vpc.Vpc.id
  cidr_block              = element(var.vpc_rds_subnets,count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.network_name}_rds-subunet_${count.index}"
    env = var.network_name
    provider = "Terraform"
  }
}
# Routing table for public subnets
resource "aws_route_table" "rtblPublic" {
  vpc_id = aws_vpc.Vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myInternetGateway.id
  }
    tags = {
    Name = "${var.network_name}_rtblPublic"
    env = var.network_name
    provider = "Terraform"
  }
}

resource "aws_route_table_association" "route" {
  count          = length(var.vpc_public_subnets)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.rtblPublic.id
}


# Elastic IP for NAT gateway
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? 1 : 0
  vpc = true
    tags = {
    Name = "${var.network_name}_eip-nat_${count.index}"
    env = var.network_name
    provider = "Terraform"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat-gw" {
  count         =  var.enable_nat_gateway ? 1 : 0
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
  depends_on    = [aws_internet_gateway.myInternetGateway]
  tags = {
    Name = "${var.network_name}_nat-gw_${count.index}"
    env = var.network_name
    provider = "Terraform"
  }
}

# Routing table for private subnets

#### With NAT Gateway ###########
resource "aws_route_table" "natrtblPrivate" {
  vpc_id = aws_vpc.Vpc.id
  count =  var.enable_nat_gateway ? length(var.vpc_private_subnets) : 0
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat-gw.*.id,count.index)
  }
   tags = {
    Name = "${var.network_name}_rtblPrivate"
    env = var.network_name
    provider = "Terraform"
  }
}
#### With Internet Gateway ########

resource "aws_route_table" "igrtblPrivate" {
  vpc_id = aws_vpc.Vpc.id
  count =  var.enable_nat_gateway ? 0 : 1
  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myInternetGateway.id
  }
   tags = {
    Name = "${var.network_name}_rtblPrivate"
    env = var.network_name
    provider = "Terraform"
  }
}
#################################################################

# Route table association Private network
#### With NAT Gateway ###########
resource "aws_route_table_association" "natprivate_route" {
  count          = var.enable_nat_gateway ? length(var.vpc_private_subnets) : 0
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.natrtblPrivate.*.id,count.index)
}
#### With Internet Gateway ########
resource "aws_route_table_association" "igprivate_route" {
  count          = var.enable_nat_gateway ? 0 : length(var.vpc_private_subnets)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.igrtblPrivate.*.id,count.index)
}


# Route table association RDS network

#### With NAT Gateway ###########
resource "aws_route_table_association" "natrds_route" {
  count          = var.enable_nat_gateway ? length(var.vpc_rds_subnets) : 0
  subnet_id      = element(aws_subnet.rds_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.natrtblPrivate.*.id,count.index)
}

#### With Internet Gateway ########
resource "aws_route_table_association" "igrds_route" {
  count          = var.enable_nat_gateway ? 0 : length(var.vpc_rds_subnets)
  subnet_id      = element(aws_subnet.rds_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.igrtblPrivate.*.id,count.index)
}