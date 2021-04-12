## Deploy SSR/Static Web Apps in CloudFront with Terraform

A terrform module to deploy a SSR/Static project in CloudFront

**Deployed**:

- private S3 origin for static files
- origin-request type Lambda EDGE function
- private versioned S3 bucket for the Lambda function artifacts
- CloudFront distribution with attached static origin and origin-request function
- Route53 A record as alias for the CloudFront distribution

Tested with Nuxt and Svelte Kit

Example:

```
provider "aws" {
  # Make sure you have enough acccess level for
  # CloudFront, CloudWatch, CloudFormation,
  # S3, Lambda, Route53, IAM, SSL Cert etc.
  profile = "aws-terraform-example-profile"
  region  = "us-east-1"
}

module "cloudfront-ssr-static-website" {

  source = "git@github.com:georgepoenaru/terraform-lambda-edge-ssr-static.git"

  # CloudFront Variables
  cloudfront_alias = "example.com"
  cloudfront_comment = "example.com website"
  # The default one is "_app/*" for Svelte Kit
  cloudfront_static_behaviour_path = "_nuxt/*"
  ssl_cert_arn = "arn:aws:acm:us-east-1:*****:certificate/****"

  # Route53 Variables
  aws_route53_zone_id = "ROUTE53_ZONE_ID"
  # OPTIONAL: If your cloudfront alias is subdomain.example.com
  aws_route53_record_subdomain = "subdomain"

  # Static S3 Variables
  s3_static_bucket_name = "my_example_static_bucket_name"
  # Relative to root directory
  static_build_dir = "build/static"

  # Lambda EDGE Variables
  lambda_description = "My SSR EDGE Function"
  lambda_edge_name = "my-ssr-example-edge-func"
  # Relative to root directory
  lambda_build_dir = "build/function"
  s3_artifacts_bucket_name = "my-ssr-artifact-bucket"

}
```
