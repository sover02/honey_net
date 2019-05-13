#!/bin/bash
cd $(dirname $0)
cd terraform/
terraform apply -auto-approve
terraform-inventory -inventory terraform.tfstate > ../var/run/honeypot_hosts
cd ../ansible/
ansible-playbook -i ../var/run/honeypot_hosts main.yml
