resource "aws_kms_key" "owasp" {
  description             = "OWASP ECS Service"
  deletion_window_in_days = 7
}

resource "aws_cloudwatch_log_group" "owasp" {
  name = "/ecs/owasp"
}
