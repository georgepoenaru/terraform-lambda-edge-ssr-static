############
# CloudFront
############
output "this_cloudfront_distribution_id" {
  description = "The identifier for the distribution."
  value       = module.cloudfront.this_cloudfront_distribution_id
}

output "this_cloudfront_distribution_arn" {
  description = "The ARN (Amazon Resource Name) for the distribution."
  value       = module.cloudfront.this_cloudfront_distribution_arn
}

output "this_cloudfront_distribution_caller_reference" {
  description = "Internal value used by CloudFront to allow future updates to the distribution configuration."
  value       = module.cloudfront.this_cloudfront_distribution_caller_reference
}

output "this_cloudfront_distribution_status" {
  description = "The current status of the distribution. Deployed if the distribution's information is fully propagated throughout the Amazon CloudFront system."
  value       = module.cloudfront.this_cloudfront_distribution_status
}

output "this_cloudfront_distribution_trusted_signers" {
  description = "List of nested attributes for active trusted signers, if the distribution is set up to serve private content with signed URLs"
  value       = module.cloudfront.this_cloudfront_distribution_trusted_signers
}

output "this_cloudfront_distribution_domain_name" {
  description = "The domain name corresponding to the distribution."
  value       = module.cloudfront.this_cloudfront_distribution_domain_name
}

output "this_cloudfront_distribution_last_modified_time" {
  description = "The date and time the distribution was last modified."
  value       = module.cloudfront.this_cloudfront_distribution_last_modified_time
}

output "this_cloudfront_distribution_in_progress_validation_batches" {
  description = "The number of invalidation batches currently in progress."
  value       = module.cloudfront.this_cloudfront_distribution_in_progress_validation_batches
}

output "this_cloudfront_distribution_etag" {
  description = "The current version of the distribution's information."
  value       = module.cloudfront.this_cloudfront_distribution_etag
}

output "this_cloudfront_distribution_hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to."
  value       = module.cloudfront.this_cloudfront_distribution_hosted_zone_id
}

output "this_cloudfront_origin_access_identities" {
  description = "The origin access identities created"
  value       = module.cloudfront.this_cloudfront_origin_access_identities
}

output "this_cloudfront_origin_access_identity_ids" {
  description = "The IDS of the origin access identities created"
  value       = module.cloudfront.this_cloudfront_origin_access_identity_ids
}

output "this_cloudfront_origin_access_identity_iam_arns" {
  description = "The IAM arns of the origin access identities created"
  value       = module.cloudfront.this_cloudfront_origin_access_identity_iam_arns
}

####################
# S3 Static Contents
####################

output "this_s3_static_bucket_id" {
  description = "The name of the bucket."
  value       = module.s3_static_bucket.this_s3_bucket_id
}
output "this_s3_static_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = module.s3_static_bucket.this_s3_bucket_arn
}

output "this_s3_static_bucket_domain_name" {
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com."
  value       = module.s3_static_bucket.this_s3_bucket_bucket_domain_name
}

output "this_s3_static_bucket_regional_domain_name" {
  description = "The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL."
  value       = module.s3_static_bucket.this_s3_bucket_bucket_regional_domain_name
}

output "this_s3_bucket_region" {
  description = "The AWS region this bucket resides in."
  value       = module.s3_static_bucket.this_s3_bucket_region
}

####################
# Lambda Function
####################

output "arn" {
  description = "The Lambda EDGE ARN"
  value       = module.lambda_at_edge.arn
}

output "function_arn" {
  description = "The Lambda Function ARN"
  value       = module.lambda_at_edge.function_arn
}
output "function_name" {
  description = "The Lambda Function Name"
  value       = module.lambda_at_edge.function_name
}
