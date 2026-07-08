module "network" {
  source = "../../modules/network"

  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
}

module "ecs" {
  source = "../../modules/ecs"

  environment    = var.environment
  vpc_id         = module.network.vpc_id
  public_subnets = module.network.public_subnets
}

module "rds" {
  source = "../../modules/rds"

  environment           = var.environment
  vpc_id                = module.network.vpc_id
  private_subnets       = module.network.private_subnets
  ecs_security_group_id = module.ecs.ecs_security_group_id
}