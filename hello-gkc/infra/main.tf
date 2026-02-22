resource "aws_ecr_repository" "spring_demo" {
  name = "spring-demo"

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"
}