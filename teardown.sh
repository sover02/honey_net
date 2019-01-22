#!/bin/bash
cd $(dirname $0)
cd terraform/
/bin/terraform destroy -auto-approve
/bin/terraform-inventory -inventory terraform.tfstate > ../var/run/honeypot_hosts
