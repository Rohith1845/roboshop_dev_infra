resource "aws_instance" "catalogue" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.catalogue_sg_id]
    subnet_id = local.private_subnet_ids

    tags = merge(
        local.common_tags,{
            Name = "${var.project_name}-${var.environment}-mongodb"
        }
    )

}

resource "terraform_data" "catalogue" {
    triggers_replace = [
        aws_instance.catalogue.id
    ]

    connection {
        type = "ssh"
        user = "ec2-user"
        password = "DevOps321"
        host = aws_instance.catalogue.private_ip
    }

    provisioner "file" {
        source = "catalogue.sh"
        destination = "/tmp/catalogue.sh"
    }

    provisioner "remote-exec" {
        inline =[
            "chmod +x /tmp/catalogue.sh" ,
            #"sudo sh /tmp/catalogue.sh"
            "sudo sh /tmp/catalogue.sh catalogue ${var.environment}"
        ]
    }
}

resource "aws_route53_record" "catalogue" {
  zone_id = var.zone_id
  name    = "catalogue.backend-alb-${var.environment}.${var.domain_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.catalogue.private_ip]
}
