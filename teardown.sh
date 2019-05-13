#!/bin/bash
cd $(dirname $0)
cd terraform/
terraform destroy -auto-approve
terraform-inventory -inventory terraform.tfstate > ../var/run/honeypot_hosts
