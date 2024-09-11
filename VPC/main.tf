// aws resource for vpc
resource "aws_vpc" "my_aws_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "ecs-vpc"
  }
}

// aws resource for subnet A
resource "aws_subnet" "my_aws_subnet_A" {
  vpc_id     = aws_vpc.my_aws_vpc.id
  cidr_block = var.subnet_cidr_block_A

  tags = {
    Name = "ecs-subnet-A"
  }
}

resource "aws_subnet" "my_aws_subnet_B" {
  vpc_id = aws_vpc.my_aws_vpc.id
  cidr_block = var.subnet_cidr_block_B

  tags = {
    Name = "ecs-subnet-B"
  }
}

// aws resource for security group
resource "aws_default_security_group" "my_aws_default_security_group" {
  vpc_id = aws_vpc.my_aws_vpc.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
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
    Name = "internetGatewayNodejs"
  }
}

resource "aws_route_table" "my_aws_route_table_A" {
  vpc_id = aws_vpc.my_aws_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_aws_internet_gateway.id
  }

  tags = {
    Name = "routeTableNodejsA"
  }
}

resource "aws_route_table" "my_aws_route_table_B" {
  vpc_id = aws_vpc.my_aws_vpc.id

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_aws_internet_gateway.id
  }

  tags = {
    Name = "routeTableNodejsB"
  }

}

resource "aws_route_table_association" "my_aws_route_table_association_A" {
  subnet_id      = aws_subnet.my_aws_subnet_A.id
  route_table_id = aws_route_table.my_aws_route_table_A.id
}

resource "aws_route_table_association" "my_aws_route_table_association_B" {
  subnet_id = aws_subnet.my_aws_subnet_B.id
  route_table_id = aws_route_table.my_aws_route_table_B.id
}