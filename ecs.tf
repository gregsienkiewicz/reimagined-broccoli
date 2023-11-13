resource "aws_ecs_cluster" "owasp" {
  name = "owasp"

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.owasp.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.owasp.name
      }
    }
  }
}

resource "aws_ecs_service" "owasp" {
  name            = "owasp-js"
  launch_type     = "FARGATE"
  cluster         = aws_ecs_cluster.owasp.id
  task_definition = aws_ecs_task_definition.owasp.arn
  desired_count   = 1

  network_configuration {
    subnets         = [aws_subnet.private_a.id, aws_subnet.private_b.id]
    security_groups = [aws_security_group.ecs.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.owasp.arn
    container_name   = "owasp-js"
    container_port   = 3000
  }
}

resource "aws_ecs_task_definition" "owasp" {
  family                   = "owasp"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs.arn
  container_definitions    = file("task-definitions/service_owasp.json")

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}
