module "s3_logs" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.10.1"

  bucket = "${local.prefix}-bucket-logs-${local.account_id}"
  versioning = {
    enabled = true
  }
  acl = "log-delivery-write"

  # Allow deletion of non-empty bucket
  force_destroy = true

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  attach_elb_log_delivery_policy = true # Required for ALB logs
  attach_lb_log_delivery_policy  = true # Required for ALB/NLB logs
}
