variable "project_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "ecs_sg_id" {
  type = string
}

variable "blue_target_group_arn" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "image_uri" {
  type = string
}

variable "db_host" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "aws_region" {
  type = string
}