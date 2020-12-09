variable "env" {
    description = "Environment name"
}

variable "cidr-nat" {
    description="cidr block"
    type = map

    default = {
        dev = "10.0.5.0/28"
        stage = "10.0.5.0/28"
    }
}

variable "cidr" {
    description="cidr block"
    type = map

    default = {
        dev = "10.0.0.0/24"
        stage = "10.0.0.0/24"
    }
}


variable "region" {
    description = "region for network configuration"
    
    type = string
    # default = "us-east-1"
}

variable "az" {
    description = "availiability for network configuration "

    type = string
}

