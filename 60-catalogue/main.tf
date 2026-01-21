resource "aws_instance" "catalogue" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.catalogue_sg_id]
    subnet_id = local.private_subnet_id

    tags = merge(
        local.common_tags,{
            Name = "${var.project_name}-${var.environment}-catalogue"
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

resource "aws_ec2_instance_state" "catalogue" {
    instance_id = aws_instance.catalogue.id
    state = "stopped"
    depends_on = [ terraform_data.catalogue ]
}

resource "aws_ami_from_instance" "catalogue" {
  name               = "${var.project_name}-${var.environment}-catalogue-ami"
  source_instance_id = aws_instance.catalogue.id
  depends_on = [ aws_ec2_instance_state.catalogue ]
  tags = merge (
    local.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-catalogue-ami"
    
    }
    )
}

resource "aws_alb_target_group" "catalogue" {
    name = "${var.project_name}-${var.environment}-catalogue"
    port = 8080
    protocol = "HTTP"
    vpc_id = local.vpc_id
    deregistration_delay = 60

    health_check {
      healthy_threshold = 2
      interval = 10
      matcher = "200-299"
      port = 8080
      protocol = "HTTP"
      timeout = 1
      unhealthy_threshold = 2
    }
}

resource "aws_launch_template" "catalogue" {
    name = "${var.project_name}-${var.environment}-catalogue"
    image_id = aws_ami_from_instance.catalogue.id
    instance_initiated_shutdown_behavior = "terminate"
    instance_type = "t3.micro"

    vpc_security_group_ids = [local.catalogue_sg_id]

    tag_specifications {
        resource_type = "instance"

        tags = merge(
            local.common_tags,
            {
                name = "${var.project_name}-${var.environment}-catalogue"
            }
        )
    }

    tag_specifications {
        resource_type = "volume"

        tags = merge(
            local.common_tags,
            {
                name = "${var.project_name}-${var.environment}-catalogue"
            }
        )
    }

    tags = merge(
            local.common_tags,
            {
                name = "${var.project_name}-${var.environment}-catalogue"
            }
        )
}


