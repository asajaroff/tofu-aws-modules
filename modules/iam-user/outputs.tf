output "iam_user_name" {
  value       = aws_iam_user.this.name
  description = "User name"
}

output "iam_user_id" {
  value       = aws_iam_user.this.id
  description = "User name"
}

output "iam_user_arn" {
  value       = aws_iam_user.this.arn
  description = "ARN of the IAM user"
}
