
############
# CloudFront
############
variable "cloudfront_alias" {
  type = string
}

variable "cloudfront_comment" {
  type = string
}

#TODO Dynamicaly path behaviour based on the static content
variable "cloudfront_static_behaviour_path" {
  type    = string
  default = "_app/*" #default path for 
}

variable "ssl_cert_arn" {
  type = string
}

##########
# Route53
##########
variable "aws_route53_zone_id" {
  type = string

}

variable "aws_route53_record_subdomain" {
  type    = string
  default = ""
}

####################
# S3 Static Contents
####################

variable "s3_static_bucket_name" {
  type = string
}

variable "static_build_dir" {
  type = string
}


####################
# Lambda EDGE
####################
variable "lambda_description" {
  type = string
}

variable "lambda_edge_name" {
  type = string
}

variable "lambda_build_dir" {
  type = string
}

variable "lambda_runtime" {
  type    = string
  default = "nodejs12.x"

}

variable "s3_artifacts_bucket_name" {
  type = string
}


