#!/bin/bash

growpart /dev/nvme0n1 4
lvextend -L +30G /dev/mapper/RootVG-homevol
xfs_growfs /home

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform

cd /home/ec2-user
git clone https://github.com/Rohith1845/roboshop_dev_infra.git
cd roboshop_dev_infra/40-database
terraform init
terraform apply -auto-approve
