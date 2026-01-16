resource "aws_instance" "bastion" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.bastion_sg_id]
    subnet_id = local.public_subnet_ids

    iam_instance_profile = aws_iam_instance_profile.bastion.name
    user_data = file("bastion.sh")
    tags = merge(
        local.common_tags,{
            Name = "${var.project_name}-${var.environment}-bastion"
        }
    )

}


resource "aws_iam_role" "admin_policy" {
    name = "BastionAdminRole"
    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
    })
    
}

resource "aws_iam_instance_profile" "bastion" {
    name = "bastion"
    role = aws_iam_role.admin_policy.name
}
