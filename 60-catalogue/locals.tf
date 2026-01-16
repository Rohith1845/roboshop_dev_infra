locals {
    ami_id = data.aws_ami.rohithdevops.id
    catalogue_sg_id = data.aws_ssm_parameter.catalogue_sg_id.value
    private_subnet_ids = data.aws_ssm_parameter.private_subnet_ids.value
    common_tags = {
        Project = var.project_name
        Environment = var.environment
        terraform  = true
    }
}

