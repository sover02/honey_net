# module "honey_pot_us-east-1" {
#   source = "./honey_net_instance"
#   providers = {
#     aws = "aws.us-east-1"
#   }
# }

module "honey_pot_us-east-2" {
  source = "./honey_net_instance"
  providers = {
    aws = "aws.us-east-2"
  }
  number = 3
}

module "honey_pot_us-west-1" {
  source = "./honey_net_instance"
  providers = {
    aws = "aws.us-west-1"
  }
}

module "honey_pot_us-west-2" {
  source = "./honey_net_instance"
  providers = {
    aws = "aws.us-west-2"
  }
}

module "honey_pot_ca-central-1" {
  source = "./honey_net_instance"
  providers = {
    aws = "aws.ca-central-1"
  }
}

module "honey_pot_eu-central-1" {
  source = "./honey_net_instance"
  providers = {
    aws = "aws.eu-central-1"
  }
}

module "honey_pot_eu-west-1" {
  source = "./honey_net_instance"
  providers = {
    aws = "aws.eu-west-1"
  }
}

module "honey_pot_eu-west-2" {
  source = "./honey_net_instance"
  providers = {
    aws = "aws.eu-west-2"
  }
}

module "honey_pot_eu-west-3" {
  source = "./honey_net_instance"
  providers = {
    aws = "aws.eu-west-3"
  }
}

module "honey_pot_ap-northeast-1" {
  source = "./honey_net_instance"
  providers = {
    aws = "aws.ap-northeast-1"
  }
}

module "honey_pot_ap-northeast-2" {
  source = "./honey_net_instance"
  providers = {
    aws = "aws.ap-northeast-2"
  }
}

module "honey_pot_ap-southeast-1" {
  source = "./honey_net_instance"
  providers = {
    aws = "aws.ap-southeast-1"
  }
}

module "honey_pot_ap-southeast-2" {
  source = "./honey_net_instance"
  providers = {
    aws = "aws.ap-southeast-2"
  }
}

module "honey_pot_ap-south-1" {
  source = "./honey_net_instance"
  providers = {
    aws = "aws.ap-south-1"
  }
}

module "honey_pot_sa-east-1" {
  source = "./honey_net_instance"
  providers = {
    aws = "aws.sa-east-1"
  }
}

output "honey_pot_ip_addresses_us-east-1" { value = module.honey_pot_us-east-1.public_ip }
output "honey_pot_ip_addresses_us-east-2" { value = module.honey_pot_us-east-2.public_ip }
output "honey_pot_ip_addresses_us-west-1" { value = module.honey_pot_us-west-1.public_ip }
output "honey_pot_ip_addresses_us-west-2" { value = module.honey_pot_us-west-2.public_ip }
output "honey_pot_ip_addresses_ca-central-1" { value = module.honey_pot_ca-central-1.public_ip }
output "honey_pot_ip_addresses_eu-central-1" { value = module.honey_pot_eu-central-1.public_ip }
output "honey_pot_ip_addresses_eu-west-1" { value = module.honey_pot_eu-west-1.public_ip }
output "honey_pot_ip_addresses_eu-west-2" { value = module.honey_pot_eu-west-2.public_ip }
output "honey_pot_ip_addresses_eu-west-3" { value = module.honey_pot_eu-west-3.public_ip }
output "honey_pot_ip_addresses_ap-northeast-1" { value = module.honey_pot_ap-northeast-1.public_ip }
output "honey_pot_ip_addresses_ap-northeast-2" { value = module.honey_pot_ap-northeast-2.public_ip }
output "honey_pot_ip_addresses_ap-southeast-1" { value = module.honey_pot_ap-southeast-1.public_ip }
output "honey_pot_ip_addresses_ap-southeast-2" { value = module.honey_pot_ap-southeast-2.public_ip }
output "honey_pot_ip_addresses_ap-south-1" { value = module.honey_pot_ap-south-1.public_ip }
output "honey_pot_ip_addresses_sa-east-1" { value = module.honey_pot_sa-east-1.public_ip }