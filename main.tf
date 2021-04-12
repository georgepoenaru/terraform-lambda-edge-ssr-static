
###########################
# S3 Static Origin
###########################
module "s3_static_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "1.22.0"

  bucket        = var.s3_static_bucket_name
  acl           = "private"
  force_destroy = true

  versioning = {
    enabled = true
  }
}

# Middleware - Content Type
module "static_files" {
  source   = "hashicorp/dir/template"
  base_dir = "${path.root}/${var.static_build_dir}"
}

# Upload Static Content
resource "aws_s3_bucket_object" "object1" {
  for_each     = module.static_files.files
  bucket       = module.s3_static_bucket.this_s3_bucket_id
  key          = each.key
  source       = each.value.source_path
  content      = each.value.content
  etag         = each.value.digests.md5
  content_type = each.value.content_type

  depends_on = [
    module.s3_static_bucket
  ]
}

###########################
# Lambda EDGE
###########################

module "lambda_at_edge" {
  source = "git@github.com:georgepoenaru/terraform-aws-lambda-at-edge.git"
  # insert the 4 required variables here
  description            = "Lambda Edge functions deployed "
  lambda_code_source_dir = "${path.root}/${var.lambda_build_dir}"
  name                   = var.lambda_edge_name
  s3_artifact_bucket     = module.s3_artifact_bucket.this_s3_bucket_id
  file_globs             = ["**"]
  runtime                = var.lambda_runtime

  depends_on = [
    module.s3_artifact_bucket
  ]

}

module "s3_artifact_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "1.22.0"
  # insert the 5 required variables here
  bucket        = var.s3_artifacts_bucket_name
  acl           = "private"
  force_destroy = true

  versioning = {
    enabled = true
  }
}

###########################
# CloudFront Origin Access Identities
###########################
data "aws_iam_policy_document" "s3_static_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_static_bucket.this_s3_bucket_arn}/*"]

    principals {
      type        = "AWS"
      identifiers = module.cloudfront.this_cloudfront_origin_access_identity_iam_arns
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.s3_static_bucket.this_s3_bucket_id
  policy = data.aws_iam_policy_document.s3_static_policy.json
}

###########################
# CloudFront
###########################
module "cloudfront" {
  source = "terraform-aws-modules/cloudfront/aws"

  aliases = [var.cloudfront_alias]

  comment             = var.cloudfront_comment
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  create_origin_access_identity = true
  origin_access_identities = {
    s3_static_bucket = "My CloudFront can access"
  }

  origin = {
    s3_static_website = {
      domain_name = module.s3_static_bucket.this_s3_bucket_bucket_regional_domain_name
      s3_origin_config = {
        origin_access_identity = "s3_static_bucket" # key in `origin_access_identities`
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3_static_website"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    forwarded_values = {
      query_string = true
      
      cookies = {
        forward = "all"
      }
    }

    lambda_function_association = {

      # Valid keys: viewer-request, origin-request, viewer-response, origin-response
      origin-request = {
        lambda_arn   = module.lambda_at_edge.arn
        include_body = true
      }
    }
  }
  #TODO Dynamicaly path behaviour based on the static content
  ordered_cache_behavior = [
    {
      path_pattern           = "*.ico"
      target_origin_id       = "s3_static_website"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods  = ["GET", "HEAD", "OPTIONS"]
      cached_methods   = ["GET", "HEAD"]
      compress         = true
    },

    {
      path_pattern           = "*.txt"
      target_origin_id       = "s3_static_website"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods  = ["GET", "HEAD", "OPTIONS"]
      cached_methods   = ["GET", "HEAD"]
      compress         = true
    },

    {
      path_pattern           = var.cloudfront_static_behaviour_path
      target_origin_id       = "s3_static_website"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods  = ["GET", "HEAD", "OPTIONS"]
      cached_methods   = ["GET", "HEAD"]
      compress         = true
    }
  ]

  viewer_certificate = {
    acm_certificate_arn = var.ssl_cert_arn
    ssl_support_method  = "sni-only"
  }

  depends_on = [
    module.lambda_at_edge,
    module.s3_static_bucket
  ]
}


##########
# Route53
##########

module "records" {
  source = "terraform-aws-modules/route53/aws//modules/records"

  zone_id = var.aws_route53_zone_id

  records = [
    {
      name = var.aws_route53_record_subdomain
      type = "A"
      alias = {
        name    = module.cloudfront.this_cloudfront_distribution_domain_name
        zone_id = module.cloudfront.this_cloudfront_distribution_hosted_zone_id
      }
    },
  ]
}




