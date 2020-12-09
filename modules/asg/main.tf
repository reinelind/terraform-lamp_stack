provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

resource "aws_key_pair" "asg-keypair" {
  key_name               = lookup(var.keypair_name, var.env)
  public_key             = base64decode(filebase64(var.public_key[var.env]))
}

resource "aws_launch_template" "asg-launch_template" {
  name_prefix            = "instances"
  image_id               = "ami-0d1ceb857bc85debb"
  instance_type          = lookup(var.instance_type, var.env)
  key_name               = aws_key_pair.asg-keypair.key_name
  vpc_security_group_ids = [var.network-sg]

  user_data = filebase64("user_data.sh")
  depends_on = [
    aws_key_pair.asg-keypair
  ]
}

resource "aws_autoscaling_group" "asg-autoscaling_group" {
  name                  = "asg"
  desired_capacity      = lookup(var.instances_desired_capacity, var.env)
  max_size              = lookup(var.instances_max_size, var.env)
  min_size              = lookup(var.instances_min_size, var.env)

  vpc_zone_identifier = [var.network-zone_identifier]

  load_balancers = [var.network-elb]

  launch_template {
    id                  = aws_launch_template.asg-launch_template.id
    version             = "$Default"
  }
  tag {     
    key                 = "LAMP-ASG" 
    value               = "true"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "asg-attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg-autoscaling_group.id
  elb                    = var.network-elb
}

resource "aws_instance" "Bastion" {
  ami                         = "ami-0d1ceb857bc85debb"
  instance_type               = lookup(var.instance_type, var.env)

  key_name                    = aws_key_pair.asg-keypair.key_name
  vpc_security_group_ids      = [var.network-sg]
  subnet_id                   = var.network-zone_identifier
  
  user_data           = file("user_data.sh")

  associate_public_ip_address = true
  tags = {
    Name = "HelloWorld"
  }

  depends_on = [
    aws_key_pair.asg-keypair
  ]
}

