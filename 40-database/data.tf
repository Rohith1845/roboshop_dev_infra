data "aws_ami" "rohithdevops" {
  owners = ["973714476881"]
  most_recent = true
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ssm_parameter" "database_subnet_ids" {
    name = "/${var.project_name}/${var.environment}/database_subnet_ids"
}

data "aws_ssm_parameter" "mongodb_sg_id" {
    name = "/${var.project_name}/${var.environment}/mongodb_sg_id"
  
}