output "cluster_name" {
    value = module.ecs.cluster_name
}

output "service_name" {
    value = module.ecs.service_name
}

output "task_family" {
  value = module.ecs.task_family
}

output "codedeploy_app_name" {
  value = module.codedeploy.app_name
}

output "deployment_group_name" {
  value = module.codedeploy.deployment_group_name
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}