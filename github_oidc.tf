resource "aws_iam_openid_connect_provider" "github_oidc" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
}

data "aws_iam_policy_document" "github_allow" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_oidc.arn]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = var.oidc_github_repositories
    }
    condition {
      test     = "ForAllValues:StringEquals"
      variable = "token.actions.githubusercontent.com:iss"
      values   = ["https://token.actions.githubusercontent.com"]
    }
    condition {
      test     = "ForAllValues:StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "github_role" {
  name                 = "GitHubActionsRole"
  max_session_duration = 3600

  assume_role_policy = data.aws_iam_policy_document.github_allow.json

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  ]
}
