module "network" {
    source = "./modules/network"

    env = var.environment_name

    region = "us-east-1"
    az     = "us-east-1a"
}
