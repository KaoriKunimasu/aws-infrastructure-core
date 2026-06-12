output "state_bucket_name" {
  description = "The name of the S3 bucket used for Terraform state storage."
  value       = aws_s3_bucket.tfstate.bucket
}

output "state_bucket_arn" {
  description = "The ARN of the S3 bucket used for Terraform state storage."
  value       = aws_s3_bucket.tfstate.arn
}

output "state_lock_table_name" {
  description = "The name of the DynamoDB table used for Terraform state locking."
  value       = aws_dynamodb_table.tfstate_lock.name
}

output "dev_backend_config" {
  description = "Suggested backend configuration for development environment."
  value       = <<-EOT
    bucket = "${aws_s3_bucket.tfstate.bucket}"
    key    = "environments/dev/terraform.tfstate"
    region = "${var.aws_region}"
    dynamodb_table = "${aws_dynamodb_table.tfstate_lock.name}"
    encrypt = true
    EOT
}

output "stg_backend_config" {
  description = "Suggested backend configuration for staging environment."
  value       = <<-EOT
    bucket = "${aws_s3_bucket.tfstate.bucket}"
    key    = "environments/stg/terraform.tfstate"
    region = "${var.aws_region}"
    dynamodb_table = "${aws_dynamodb_table.tfstate_lock.name}"
    encrypt = true
    EOT
}

output "prod_backend_config" {
  description = "Suggested backend configuration for production environment."
  value       = <<-EOT
    bucket = "${aws_s3_bucket.tfstate.bucket}"
    key    = "environments/prod/terraform.tfstate"
    region = "${var.aws_region}"
    dynamodb_table = "${aws_dynamodb_table.tfstate_lock.name}"
    encrypt = true
    EOT
}