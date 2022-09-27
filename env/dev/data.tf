data "aws_subnet" "service_subnets" {
  filter {
    name   = "tag:subnet_type"
    values = ["microservices "]
  }
}