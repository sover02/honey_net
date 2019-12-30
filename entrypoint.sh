#!/bin/sh

# Set up SSH Keys
mkdir ~/.ssh
echo "$INPUT_SSH_PRIVATE_KEY" > ~/.ssh/honeypot_ec2-user.pem
chmod 400 ~/.ssh/honeypot_ec2-user.pem
echo "$INPUT_SSH_PUBLIC_KEY" > ~/.ssh/honeypot_ec2-user.pub
chmod 400 ~/.ssh/honeypot_ec2-user.pub

# Set up AWS CLI
mkdir ~/.aws
echo "[default]" > ~/.aws/credentials
echo "aws_access_key_id = $INPUT_AWS_ACCESS_KEY_ID" >> ~/.aws/credentials
echo "aws_secret_access_key = $INPUT_AWS_SECRET_ACCESS_KEY" >> ~/.aws/credentials

# Run ansible playbook
cd /app/ansible
ansible-playbook main.yml
