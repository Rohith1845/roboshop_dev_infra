variable "vpc_tags" {
    default = {
      Purpose = "Roboshop vpc"
      DontDelete = "true"
    }
  
}

variable "vpc_cidr_blocks" {
  default = "10.0.0.0/16"
}
variable "project_name" {
  type = string
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24" , "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.11.0/24" , "10.0.12.0/24"]
}

variable "database_subnet_cidrs" {
  default = ["10.0.21.0/24" , "10.0.22.0/24"]
}