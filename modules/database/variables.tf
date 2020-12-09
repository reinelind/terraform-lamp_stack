variable "env" {
  type = string
}

variable "region" {
  type = string
}

variable "db_name" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "az_list" {
  type = list(string)
}

variable "db_count" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "db_cidr-subnet1" {
    description="cidr block for db"
    type = map

    default = {
        dev = "10.0.2.0/28"
        stage = "10.0.2.16/28"
    }
}

variable "db_cidr-subnet2" {
    description="cidr block for db"
    type = map

    default = {
        dev = "10.0.3.0/28"
        stage = "10.0.3.16/28"
    }
}