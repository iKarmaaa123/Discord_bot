// instantiating vpc child module from parent module
module "vpcmodule" {
  source = "../VPC"
}

// ecs resource
resource "aws_ecs_cluster" "my_aws_ecs_cluster" {
  name = "nodejsapptestcluster"
}

// ecs task definitions
resource "aws_ecs_task_definition" "my_aws_ecs_task_definition" {
  family                   = "app-first-task"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "app-first-task",
      "image": "648767092427.dkr.ecr.us-east-1.amazonaws.com/test-nodejs-application",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"    
  memory                   = 512         
  cpu                      = 256        
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
}

// iam role
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = "${aws_iam_role.ecsTaskExecutionRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

// ecs service
resource "aws_ecs_service" "my_aws_ecs_service" {
  name            = "nodejsappservice"
  cluster         = aws_ecs_cluster.my_aws_ecs_cluster.id
  task_definition = aws_ecs_task_definition.my_aws_ecs_task_definition.arn
  desired_count   = 2
  launch_type = "FARGATE"

  network_configuration {
    subnets = [module.vpcmodule.subnet_id_A, module.vpcmodule.subnet_id_B]
    security_groups = [module.vpcmodule.default_security_group_id]
    assign_public_ip = true
  }
}
//gndjngjdsbgjbs
