output "aws_iam_oidc_github_role" {
  value       = aws_iam_role.github_role.arn
  description = "The Amazon Resource Name (ARN) of the GitHubActionsRole role."
}
