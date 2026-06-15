resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = {
    Name        = "main-vpc"
    Environment = var.environment
  }
}


resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone
  tags = {
    Name        = "main-subnet"
    Environment = var.environment
  }
  map_public_ip_on_launch = true
}


resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "main-route-table"
    Environment = var.environment
  }
}

resource "aws_route" "main" {
  route_table_id         = aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "main-igw"
    Environment = var.environment
  }
}
