output "redshift_endpoint" {
  description = "Redshift Serverless endpoint for dbt connection"
  value       = aws_redshiftserverless_workgroup.main.endpoint[0].address
}

output "redshift_db_name" {
  description = "Redshift database name"
  value       = aws_redshiftserverless_namespace.main.db_name
}

output "redshift_copy_role_arn" {
  description = "IAM role ARN for Redshift COPY from S3"
  value       = aws_iam_role.redshift_copy.arn
}
