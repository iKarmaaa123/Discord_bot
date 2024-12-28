resource "aws_iam_role" "ecs_task_execution_role" {
  name = "role-name"
 
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role" "ecs_task_role" {
  name = "role-name-task"
 
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

/*
resource "aws_iam_role" "yace_role" {
  name = "test_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
      },
    ]
  })
}
*/

resource "aws_iam_policy" "ecs_secrets_policy" {
  name        = "ecsSecretsManagerPolicy"
  description = "Policy for ECS to access Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = "arn:aws:secretsmanager:us-east-1:648767092427:secret:discord_token-02w01x"
      }
    ]
  })
}

# Define the policy
resource "aws_iam_policy" "yace_policy" {
  name        = "YACEPermissionsPolicy"
  description = "Policy to allow YACE to scrape ContainerInsights metrics"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "tag:GetResources",
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
        ],
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}

# Attach the policy to an existing IAM user
/*
resource "aws_iam_role_policy_attachment" "yace_role_policy_attachment" {
  role       = aws_iam_role.yace_role.name
  policy_arn = aws_iam_policy.yace_policy.arn
}
*/

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_secrets_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_secrets_policy.arn
}

resource "aws_iam_user_policy_attachment" "project_user_policy_attachment" {
  user       = "project"
  policy_arn = aws_iam_policy.yace_policy.arn
}
