resource "aws_ecr_repository" "owasp" {
  name                 = "owasp"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "owasp" {
  repository = aws_ecr_repository.owasp.name

  policy = file("./ecr_lifecycle_policy.json")
}

resource "aws_ecr_registry_scanning_configuration" "test" {
  scan_type = "ENHANCED"

  rule {
    scan_frequency = "SCAN_ON_PUSH"
    repository_filter {
      filter      = "*"
      filter_type = "WILDCARD"
    }
  }

  rule {
    scan_frequency = "CONTINUOUS_SCAN"
    repository_filter {
      filter      = "owasp"
      filter_type = "WILDCARD"
    }
    repository_filter {
      filter      = "prod"
      filter_type = "WILDCARD"
    }
  }
}
