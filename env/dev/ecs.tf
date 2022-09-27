module "ecs" {
  source      = "git@bitbucket.org:cbssmobile/terraform-aws-ecs.git?ref=v0.0.4"

  cost_center                               = local.service.cost_center
  owner                                     = local.service.owner
  prefix                                    = local.service.prefix
  environment                               = local.service.environment
  name                                      = local.service.name
  allowed_subnets                           = local.service.allowed_subnets
  vpc_id                                    = local.service.vpc_id
  workload                                  = local.service.workload
  alb_https_certificate                     = data.aws_acm_certificate.certificate.arn
  alb_security_group_id                     = aws_security_group.alb_sg.id
  cluster_name                              = local.service.cluster_name
  service_desired_count                     = local.service.desired_count
  service_health_check_grace_period_seconds = local.service.health_check_grace_period_seconds
  service_security_group_id                 = aws_security_group.service_sg.id
  task_definition_imagem_name               = local.service.task_definition.imagem_name
  task_definition_imagem_version            = local.service.task_definition.imagem_version
  task_definition_entry_point               = local.service.task_definition.entry_point
  task_definition_memory                    = local.service.task_definition.memory
  task_definition_cpu                       = local.service.task_definition.cpu
  task_execution_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "01"
        Effect = "Allow"
        Action = [
          "ecr:DescribeImageScanFindings",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetAuthorizationToken",
          "ecr:ListTagsForResource",
          "ecr:ListImages",
          "logs:PutLogEvents",
          "logs:CreateLogStream",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:DescribeRepositories",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetRepositoryPolicy",
          "ecr:GetLifecyclePolicy"
        ]
        Resource = "*"
      },
      {
        Sid      = "02"
        Effect   = "Allow"
        Action   = "secretsmanager:GetSecretValue"
        Resource = [for s in local.service.task_definition.secrets : s.valueFrom]
      }
    ]
  })
}