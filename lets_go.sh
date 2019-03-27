#!/bin/bash
cd $(dirname $0)
cd terraform/
/bin/terraform apply -auto-approve
/bin/terraform-inventory -inventory terraform.tfstate > ../var/run/honeypot_hosts
cd ../ansible/
ansible-playbook -i ../var/run/honeypot_hosts main.yml
