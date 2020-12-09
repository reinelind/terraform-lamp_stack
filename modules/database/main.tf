provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

resource "aws_subnet" "network-private-subnet1" {
  vpc_id    =  var.vpc_id
  cidr_block = lookup(var.db_cidr-subnet1, var.env)
  availability_zone = element(var.az_list,1)
}

resource "aws_subnet" "network-private-subnet2" {
  vpc_id    =  var.vpc_id
  cidr_block = lookup(var.db_cidr-subnet2, var.env)
  availability_zone = element(var.az_list,2)
}


resource "aws_security_group" "database-sg" {
    name        = "sql"
    description = "allow traffic to 3306 port"
    vpc_id      = var.vpc_id
    ingress {
        description = "sql"
        from_port   = 3306
        to_port     = 3306 
        protocol    = "tcp"
        cidr_blocks  = [aws_subnet.network-private-subnet1.cidr_block]
    }

    egress {
        description = "All traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks  = [aws_subnet.network-private-subnet1.cidr_block]
    }
}

resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "lamp-cluster-${var.env}-subnet-group"
  subnet_ids = [aws_subnet.network-private-subnet1.id, aws_subnet.network-private-subnet2.id]
}

resource "aws_rds_cluster" "database-cluster" {
  cluster_identifier = "demo"
  availability_zones = var.az_list
  database_name      = var.db_name
  master_username    = var.username
  master_password    = var.password
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.database-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.aurora_subnet_group.name

  depends_on = [ aws_db_subnet_group.aurora_subnet_group ]
}

resource "aws_rds_cluster_instance" "database-instances" {
  count              = var.db_count
  identifier         = "lamp-cluster-${var.env}"
  cluster_identifier = aws_rds_cluster.database-cluster.id
  instance_class     = "db.t3.small"
  engine             = aws_rds_cluster.database-cluster.engine
  engine_version     = aws_rds_cluster.database-cluster.engine_version
  
}

