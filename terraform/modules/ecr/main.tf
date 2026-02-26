resource "aws_ecr_repository" "this" {
  name = "${var.project_name}-repo-nandini"

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"
}