module "network" {
    source = "./modules/network"

    env = var.environment_name

    region = "us-east-1"
    az     = "us-east-1a"
}

module "asg" {
    source = "./modules/asg"

    env = var.environment_name

    region = "us-east-1"

    network-sg  = module.network.network-sg
    network-elb = module.network.network-elb_id
    network-zone_identifier = module.network.network-subnet_id

}

