// aws resource for vpc
resource "aws_vpc" "my_aws_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "ecs-vpc"
  }
}

// aws resource for subnet
resource "aws_subnet" "my_aws_subnet" {
  vpc_id     = aws_vpc.my_aws_vpc.id
  cidr_block = var.subnet_cidr_block

  tags = {
    Name = "ecs-subnet"
  }
}

// aws resource for security group
resource "aws_default_security_group" "my_aws_default_security_group" {
  vpc_id = aws_vpc.my_aws_vpc.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol = "-1"
    self = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "my_aws_internet_gateway" {
  vpc_id = aws_vpc.my_aws_vpc.id

  tags = {
    Name = "internetGatewayEcs"
  }
}

resource "aws_route_table" "my_aws_route_table" {
  vpc_id = aws_vpc.my_aws_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_aws_internet_gateway.id
  }

  tags = {
    Name = "routeTableEcs"
  }
}

resource "aws_route_table_association" "my_aws_route_table_association" {
  subnet_id      = aws_subnet.my_aws_subnet.id
  route_table_id = aws_route_table.my_aws_route_table.id
}