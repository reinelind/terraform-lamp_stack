variable "keypair_name" {
    type = map 
    default = {
        dev  = "dev_key"
        prod = "prod_key"
    }
}

variable "public_key" {
    type = map
    default = {
        dev =  "./dev_key.pub"
        prod = "./prod_key.pub"
    }
}

variable "instance_type" {
    type = map
    default = {
        dev = "t2.micro"
        prd = "t2.medium"
    }
}

variable "instances_desired_capacity" {
    type = map 
    default ={
        dev  = 2
        prod = 4
    }
}

variable "instances_max_size" {
    type = map
    default = {
        dev = 3
        prod = 8
    }
}

variable "instances_min_size" {
    type = map
    default = {
        dev = 1
        prod = 3
    }
}

variable "network-zone_identifier" {
    type = string
}

variable "network-elb" {
    type = string
}

variable "network-sg" {
    type = string
}

variable "region" {
    description = "availability zone for network configuration"
    
    # default = "us-east-1"
}

variable "env" {
    type = string
}
