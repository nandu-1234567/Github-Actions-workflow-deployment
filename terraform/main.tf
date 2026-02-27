module "network" {
  source       = "./modules/network"
  project_name = var.project_name
}

module "alb" {
  source      = "./modules/alb"
  project_name = var.project_name
  vpc_id       = module.network.vpc_id
  subnet_ids   = module.network.subnet_ids
  alb_sg_id    = module.network.alb_sg_id
}


module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
  ecr_repository_url = module.ecr.repository_url
}

module "ecs" {
  source               = "./modules/ecs"
  aws_region           = var.aws_region
  project_name         = var.project_name
  subnet_ids           = module.network.subnet_ids
  ecs_sg_id            = module.network.ecs_sg_id
  blue_target_group_arn = module.alb.blue_tg_arn
  execution_role_arn   = var.execution_role_arn
  image_uri            = "${module.ecr.repository_url}:latest"
  db_host     = module.rds.db_endpoint
  db_name     = module.rds.db_name
  db_username = var.db_username
  db_password = var.db_password
}

module "codedeploy" {
  source = "./modules/codedeploy"

  project_name       = var.project_name
  cluster_name       = module.ecs.cluster_name
  service_name       = module.ecs.service_name
  blue_tg_name       = module.alb.blue_tg_name
  green_tg_name      = module.alb.green_tg_name
  listener_arn       = module.alb.listener_arn
  codedeploy_role_arn = var.codedeploy_role_arn
}

module "rds" {
  source        = "./modules/rds"
  project_name  = var.project_name
  subnet_ids    = module.network.subnet_ids
  ecs_sg_id     = module.network.ecs_sg_id
  db_username   = var.db_username
  db_password   = var.db_password
}
