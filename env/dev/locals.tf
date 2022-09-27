locals {
  environment = "sit"
  vpc_id      = "vpc-00000000000000"

  availability_zones = toset([for zone in data.aws_subnet.service_subnets : zone.availability_zone])
  cost_center        = "OPENFINANCE-56000110"

  workload = {
    owner = "desenvolvimento"
    name  = "of-out-serv-channels"
  }
}

local {
   ecr = {
    name                               = "openfinance/of-out-serv-channels"
    image_tag_mutability               = "IMMUTABLE"  
    scan_on_push                       = true
    expire_older_images                = false 
    ecr_accounts_to_allow_cross_accout = ["772699454550"]              
    image_count_more_than_days         = 10     
   }
}

locals {
  service = {
    environment     = local.environment
    owner           = local.workload.owner
    prefix          = "of"
    cost_center     = local.cost_center
    workload        = local.workload.name
    name            = local.workload.name
    vpc_id          = local.vpc_id
    allowed_subnets = [data.aws_subnet.service_subnets]
    cluster_name    = "sit-openfinance"
    task_definition = {
      cpu            = 1024
      memory         = 2048
      imagem_name    = "772699454550.dkr.ecr.sa-east-1.amazonaws.com/${local.ecr.name}"
      imagem_version = "latest"
      entry_point = [
        "java",
        "-Duser.timezone=GMT-3",
        "-Djava.security.egd=file:/dev/./urandom",
        "-jar",
        "products.services.jar"
      ]

      environment_variables = [
        {
          name  = "spring.profiles.active"
          value = "dev"
        }
      ]
      secrets = [
        {
        }
      ]
    }
    desired_count                     = 2
    health_check_grace_period_seconds = "60"
  }
}

locals {
  sg_alb = {
    name        = "alb-${local.workload.name}-sg"
    description = "${local.workload.name} alb security group"
    vpc_id      = local.vpc_id
    ingress = toset([
      {
        description      = "Allow HTTPS"
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        prefix_list_ids  = []
        security_groups  = []
        self             = null
      },
      {
        description      = "Allow HTTP"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        prefix_list_ids  = []
        security_groups  = []
        self             = null
      }
    ])

    egress = toset([{
      description      = "Allow All"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = null
    }])

    tags = {
      Name = "alb-${local.workload.name}-sg"
    }
  }
}

locals {
  sg_service = {
    name        = "${local.workload.name}-sg"
    description = "${local.workload.name} security group"
    vpc_id      = local.vpc_id

    ingress = toset([
      {
        description      = "Allow Request From Target Group"
        from_port        = 8080
        to_port          = 8080
        protocol         = "tcp"
        cidr_blocks      = []
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = [aws_security_group.alb_sg.id]
        self             = null
      }
    ])

    egress = toset([{
      description      = "Allow all"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = null
    }])

    tags = {
      Name = "${local.workload.name}-sg"
    }
  }
}