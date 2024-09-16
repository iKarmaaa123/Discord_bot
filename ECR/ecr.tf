// ecr repository
resource "aws_ecr_repository" "my_aws_ecr_repository" {
  name                 = "test-nodejs-application"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}