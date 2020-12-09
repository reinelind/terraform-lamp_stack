provider "aws" {
  version = "~> 3.0"
  region  = var.region
}

resource "aws_vpc" "network-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "network-subnet" {
  vpc_id    = aws_vpc.network-vpc.id     
  cidr_block = lookup(var.cidr, var.env)
  availability_zone = var.az
}

resource "aws_subnet" "network-subnet-nat" {
  vpc_id    = aws_vpc.network-vpc.id     
  cidr_block = lookup(var.cidr-nat, var.env)
  availability_zone = var.az
}


resource "aws_internet_gateway" "network-igw" {
  vpc_id = "${aws_vpc.network-vpc.id}"
}

resource "aws_security_group" "network-sg" {
  depends_on = [ aws_vpc.network-vpc ]

    name        = "http and ssh"
    description = "allow http and ssh traffic"
    vpc_id      = aws_vpc.network-vpc.id
    ingress {
        description = "http"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]
    }
    ingress {
        description = "ssh"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]
    }

    egress {
        description = "All traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks  = ["0.0.0.0/0"]
    }
}

resource "aws_route_table" "network-rt" {
  vpc_id = aws_vpc.network-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.network-igw.id
  }
}

resource "aws_route_table" "nat-rt"{

  vpc_id = aws_vpc.network-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_main_route_table_association" "network-main_rt_association" {
  vpc_id         = aws_subnet.network-subnet.id
  route_table_id = aws_route_table.network-rt.id
}

resource "aws_route_table_association" "network-secondary_rt_association" {
  subnet_id         = aws_subnet.network-subnet-nat.id
  route_table_id    = aws_route_table.nat-rt.id
}


resource "aws_elb" "network-elb" {
  name = "elb"
  subnets   = [aws_subnet.network-subnet.id]
  security_groups = [aws_security_group.network-sg.id]

  # listener {
  #   instance_port     = 80
  #   instance_protocol = "http"
  #   lb_port           = 80
  #   lb_protocol       = "http"
  # }
  
  listener {
    instance_port     = 22
    instance_protocol = "tcp"
    lb_port           = 22
    lb_protocol       = "tcp"
  }
  
  depends_on = [
    aws_internet_gateway.network-igw
  ]
}

resource "aws_eip" "nat-eip" {

depends_on = [
  aws_internet_gateway.network-igw
]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.network-subnet.id

  depends_on = [
    aws_internet_gateway.network-igw
  ]
}
############
