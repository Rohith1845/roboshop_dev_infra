# open source module
# module "catalogue" {
#   source = "terraform-aws-modules/security-group/aws"

#   name        = "${local.common_name_suffix}-catalogue"
#   use_name_prefix = false
#   description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
#   vpc_id      = data.aws_ssm_parameter.vpc_id.value

# }

module "sg" {
  source = "git::https://github.com/Rohith1845/terraform-aws-sg.git?ref=main"

  count = length(var.sg_name)
  project_name = var.project_name
  environment = var.environment
  vpc_id = local.vpc_id
  sg_name = var.sg_name[count.index]
  sg_description = "created for ${var.sg_name[count.index]}"

}

# resource "aws_security_group_rule" "frontend-lb" {
#   type = "ingress"
#   security_group_id = module.sg[9].sg_id
#   source_security_group_id = module.sg[11].sg_id
#   from_port = 80
#   protocol = "tcp"
#   to_port = 80

# }