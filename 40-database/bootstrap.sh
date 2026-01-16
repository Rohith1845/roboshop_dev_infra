#!/bin/bash


dnf install -y
# ansible-pull -u https://github.com/Rohith1845/roboshop-ansible-roles-tf.git -e component=$component main.yaml
# git clone ansible-playbook
# cd ansible-playbook
# ansible-playbook -i inventory main.yaml

REPO_URL=https://github.com/Rohith1845/roboshop-ansible-roles-tf.git
REPO_DIR=/opt/roboshop/ansible
ANSIBLE_DIR=roboshop-ansible-roles-tf
component=$1

mkdir -p $REPO_DIR
mkdir -p /var/log/roboshop/
touch ansible.log

cd $REPO_DIR

# check if ansible repo is available or not

if [ -d $ANSIBLE_DIR ]; then
    cd $ANSIBLE_DIR
    git pull
else
    git clone $REPO_DIR
    cd $ANSIBLE_DIR
fi

ansible-playbook -e component=$component main.yaml

