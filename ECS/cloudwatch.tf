resource "aws_cloudwatch_log_group" "my_aws_cloudwatch_log_group" {
  name = "ECS_DISCORD-BOT-LOG_GROUP"
}

resource "aws_cloudwatch_log_stream" "my_aws_cloudwatch_log_stream" {
  name           = "ECS-DISCORD-BOT-LOG_STREAM"
  log_group_name = aws_cloudwatch_log_group.my_aws_cloudwatch_log_group.name
}

resource "aws_cloudwatch_metric_alarm" "foobar" {
  alarm_name                = "discordbotalarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "This metric monitors ecs cpu utilisation"
}



resource "aws_cloudwatch_dashboard" "my_aws_cloudwatch_dashboard" {
  dashboard_name = "demo-dashboard-discordbotcluster"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/ECS",
              "CPUUtilization",
              "ClusterName",
              "discordbotcluster",
              "ServiceName",
              "discordbotservice"
            ]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "discordbotservice - CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 7
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/ECS",
              "MemoryUtilization",
              "ClusterName",
              "discordbotcluster",
              "ServiceName",
              "discordbotservice"
            ]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "discordbotservice - Memory Utilization"
        }
      },
    ]
  })
}

