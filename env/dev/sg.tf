resource "aws_security_group" "alb_sg" {
  name        = local.sg_alb.name
  description = local.sg_alb.description
  vpc_id      = local.sg_alb.vpc_id
  ingress     = local.sg_alb.ingress
  egress      = local.sg_alb.egress
  tags        = local.sg_alb.tags
}

resource "aws_security_group" "service_sg" {
  name        = local.sg_service.name
  description = local.sg_service.description
  vpc_id      = local.sg_service.vpc_id
  ingress     = local.sg_service.ingress
  egress      = local.sg_service.egress
  tags        = local.sg_service.tags
}