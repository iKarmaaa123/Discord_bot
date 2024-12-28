// ecr repository
resource "aws_ecr_repository" "my_aws_ecr_repository" {
  name                 = "test-discord-bot"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}
