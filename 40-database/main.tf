resource "aws_instance" "mongodb" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.mongodb_sg_id]
    subnet_id = local.database_subnet_ids

    tags = merge(
        local.common_tags,{
            Name = "${var.project_name}-${var.environment}-mongodb"
        }
    )

}

resource "terraform_data" "mongodb" {
    triggers_replace = [
        aws_instance.mongodb.id
    ]

    connection {
        type = "ssh"
        user = "ec2-user"
        password = "DevOps321"
        host = aws_instance.mongodb.private_ip
    }

    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }

    provisioner "remote-exec" {
        inline =[
            "chmod +x /tmp/bootstrap.sh" ,
            #"sudo sh /tmp/bootstrap.sh"
            "sudo sh /tmp/bootstrap.sh mongodb dev"
        ]
    }
}

resource "aws_instance" "redis" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.redis_sg_id]
    subnet_id = local.database_subnet_ids

    tags = merge(
        local.common_tags,{
            Name = "${var.project_name}-${var.environment}-redis"
        }
    )

}

resource "terraform_data" "redis" {
    triggers_replace = [
        aws_instance.redis.id
    ]

    connection {
        type = "ssh"
        user = "ec2-user"
        password = "DevOps321"
        host = aws_instance.redis.private_ip
    }

    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }

    provisioner "remote-exec" {
        inline =[
            "chmod +x /tmp/bootstrap.sh" ,
            #"sudo sh /tmp/bootstrap.sh"
            "sudo sh /tmp/bootstrap.sh redis dev"
        ]
    }
}

resource "aws_instance" "rabbitmq" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.rabbitmq_sg_id]
    subnet_id = local.database_subnet_ids

    tags = merge(
        local.common_tags,{
            Name = "${var.project_name}-${var.environment}-rabbitmq"
        }
    )

}

resource "terraform_data" "rabbitmq" {
    triggers_replace = [
        aws_instance.rabbitmq.id
    ]

    connection {
        type = "ssh"
        user = "ec2-user"
        password = "DevOps321"
        host = aws_instance.rabbitmq.private_ip
    }

    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }

    provisioner "remote-exec" {
        inline =[
            "chmod +x /tmp/bootstrap.sh" ,
            #"sudo sh /tmp/bootstrap.sh"
            "sudo sh /tmp/bootstrap.sh rabbitmq dev"
        ]
    }
}

resource "aws_instance" "mysql" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.mysql_sg_id]
    subnet_id = local.database_subnet_ids

    iam_instance_profile = aws_iam_instance_profile.mysql.name
    tags = merge(
        local.common_tags,{
            Name = "${var.project_name}-${var.environment}-mysql"
        }
    )

}

resource "aws_iam_role_policy" "ssm_policy" {
    name = "EC2SSMPARAMETERREAD"
    role = aws_iam_role.ec2_role.name
    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
            "Effect": "Allow",
            "Action": [
            "ssm:GetParameter",
            "ssm:GetParameters",
            "ssm:GetParametersByPath"
        ],
        "Resource": "arn:aws:ssm:us-east-1:*:parameter/roboshop/*"
        }
        ]
    })
}

resource "aws_iam_role" "ec2_role" {
    name = "EC2SSMPARAMETERREAD"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect    = "Allow"
            Principal = { Service = "ec2.amazonaws.com" }
            Action    = "sts:AssumeRole"
        }]
    })
    
}

resource "aws_iam_instance_profile" "mysql" {
    name = "mysql"
    role = aws_iam_role.ec2_role.name
}

resource "terraform_data" "mysql" {
    triggers_replace = [
        aws_instance.mysql.id
    ]

    connection {
        type = "ssh"
        user = "ec2-user"
        password = "DevOps321"
        host = aws_instance.mysql.private_ip
    }

    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }

    provisioner "remote-exec" {
        inline =[
            "chmod +x /tmp/bootstrap.sh" ,
            #"sudo sh /tmp/bootstrap.sh"
            "sudo sh /tmp/bootstrap.sh mysql dev"
        ]
    }
}