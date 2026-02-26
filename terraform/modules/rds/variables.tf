variable "project_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "ecs_sg_id" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}