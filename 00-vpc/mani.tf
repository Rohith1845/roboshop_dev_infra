module "vpc" {
    #source = "../terraform_vpc_module"
    source = "git::https://github.com/Rohith1845/terraform_vpc_module.git?ref=main"
    # vpc_cidr_blocks = "10.0.0.0/16"
    # project_name = "roboshop"
    # environment = "dev"

    vpc_cidr_blocks = var.vpc_cidr_blocks
    project_name = var.project_name
    environment = var.environment
    vpc_tags = var.vpc_tags

    public_subnet_cidrs = var.public_subnet_cidrs

    private_subnet_cidrs = var.private_subnet_cidrs

    database_subnet_cidrs = var.database_subnet_cidrs

    is_peering_required = true
}   
