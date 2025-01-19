// instantiating vpc child module from parent module
module "vpcmodule" {
  source = "../VPC"
}

// ecs cluster
resource "aws_ecs_cluster" "my_aws_ecs_cluster" {
  name = "discordbotcluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    environment = "development"
    project     = "discordbotcluster"
  }
}

// ecs task definitions
resource "aws_ecs_task_definition" "my_aws_ecs_task_definition" {
  family                   = "discord-bot"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "discord-bot",
      "image": "648767092427.dkr.ecr.us-east-1.amazonaws.com/test-discord-bot:latest",
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
        "awslogs-group": "ECS_DISCORD-BOT-LOG_GROUP",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "ECS-DISCORD-BOT-LOG_STREAM"
        }
      },
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
}

// ecs service
resource "aws_ecs_service" "my_aws_ecs_service" {
  name            = "discordbotservice"
  desired_count   = 1
  cluster         = aws_ecs_cluster.my_aws_ecs_cluster.id
  task_definition = aws_ecs_task_definition.my_aws_ecs_task_definition.arn
  launch_type     = "FARGATE"

  tags = {
    environment = "evelopment"
  }

  network_configuration {
    subnets          = [module.vpcmodule.subnet_id]
    security_groups  = [module.vpcmodule.default_security_group_id]
    assign_public_ip = true
  }
}