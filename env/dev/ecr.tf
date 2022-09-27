module "ecr" {
  source                             = "git@bitbucket.org:cbssmobile/terraform-aws-ecr.git?ref=v1.0.0"
  name                               = local.ecr.name
  image_tag_mutability               = local.ecr.image_tag_mutability
  scan_on_push                       = local.ecr.scan_on_push
  expire_older_images                = local.ecr.expire_older_images
  ecr_accounts_to_allow_cross_accout = local.ecr.ecr_accounts_to_allow_cross_accout
  image_count_more_than_days         = local.ecr.image_count_more_than_days
}