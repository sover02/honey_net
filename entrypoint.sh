#!/bin/sh

# Set up SSH Keys
mkdir ~/.ssh
echo "$SSH_PRIVATE_KEY" > ~/.ssh/honeypot_ec2-user.pem
chmod 400 ~/.ssh/honeypot_ec2-user.pem
echo "$SSH_PUBLIC_KEY" > ~/.ssh/honeypot_ec2-user.pub
chmod 400 ~/.ssh/honeypot_ec2-user.pub

# Set up AWS CLI
mkdir ~/.aws
echo "[default]" > ~/.aws/credentials
echo "aws_access_key_id = $AWS_ACCESS_KEY_ID" >> ~/.aws/credentials
echo "aws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >> ~/.aws/credentials

# Run ansible playbook
cd /app/ansible
ansible-playbook main.yml
