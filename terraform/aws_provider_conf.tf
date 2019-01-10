# List of regions for various uses

variable "aws_regions" {
  description = "Deploy to these regions"
  type = "list"
  default = ["us-east-1", 
    "us-east-2",
    "us-west-1", 
    "us-west-2",
    "ca-central-1",
    "eu-central-1", 
    "eu-west-1", 
    "eu-west-2", 
    "eu-west-3", 
    "eu-north-1",
    "ap-northeast-1", 
    "ap-northeast-2", 
    "ap-northeast-3",
    "ap-southeast-1", 
    "ap-southeast-2", 
    "ap-south-1",
    "sa-east-1"]
}


# Establish multiple region providers
# `count` is not supported for providers, so have to declare manually
provider "aws" { } # Need a base to build on top of
provider "aws" { alias = "us-east-1", region = "us-east-1" }
provider "aws" { alias = "us-east-2", region = "us-east-2" }
provider "aws" { alias = "us-west-1", region = "us-west-1" }
provider "aws" { alias = "us-west-2", region = "us-west-2" }
provider "aws" { alias = "ca-central-1", region = "ca-central-1" }
provider "aws" { alias = "eu-central-1", region = "eu-central-1" }
provider "aws" { alias = "eu-west-1", region = "eu-west-1" }
provider "aws" { alias = "eu-west-2", region = "eu-west-2" }
provider "aws" { alias = "eu-west-3", region = "eu-west-3" }
provider "aws" { alias = "eu-north-1", region = "eu-north-1" }
provider "aws" { alias = "ap-northeast-1", region = "ap-northeast-1" }
provider "aws" { alias = "ap-northeast-2", region = "ap-northeast-2" }
provider "aws" { alias = "ap-northeast-3", region = "ap-northeast-3" }
provider "aws" { alias = "ap-southeast-1", region = "ap-southeast-1" }
provider "aws" { alias = "ap-southeast-2", region = "ap-southeast-2" }
provider "aws" { alias = "ap-south-1", region = "ap-south-1" }
provider "aws" { alias = "sa-east-1", region = "sa-east-1" }


# Get latest AMI image from each region
data "aws_ami" "amazonlinux_latest_us-east-1" {
  provider = "aws.us-east-1"
  most_recent = true
  filter { name = "owner-alias", values = ["amazon"] }
  filter { name = "name", values = ["amzn2-ami-hvm*"] }
  filter { name = "architecture", values = ["x86_64*"] }
}

data "aws_ami" "amazonlinux_latest_us-east-2" {
  provider = "aws.us-east-2"
  most_recent = true
  filter { name = "owner-alias", values = ["amazon"] }
  filter { name = "name", values = ["amzn2-ami-hvm*"] }
  filter { name = "architecture", values = ["x86_64*"] }
}

data "aws_ami" "amazonlinux_latest_us-west-1" {
  provider = "aws.us-west-1"
  most_recent = true
  filter { name = "owner-alias", values = ["amazon"] }
  filter { name = "name", values = ["amzn2-ami-hvm*"] }
  filter { name = "architecture", values = ["x86_64*"] }
}

data "aws_ami" "amazonlinux_latest_us-west-2" {
  provider = "aws.us-west-2"
  most_recent = true
  filter { name = "owner-alias", values = ["amazon"] }
  filter { name = "name", values = ["amzn2-ami-hvm*"] }
  filter { name = "architecture", values = ["x86_64*"] }
}

# Set up ssh key
data "local_file" "ssh_key_text_pub" {
    filename = "${pathexpand("~/.ssh/honeypot_ec2-instance_id_rsa.pub")}"
}

resource "aws_key_pair" "honeypot_ec2_key_pub_us-east-2" {
  provider = "aws.us-east-2"
  key_name   = "honeypot_ec2_key_pub"
  public_key = "${data.local_file.ssh_key_text_pub.content}"
}

resource "aws_key_pair" "honeypot_ec2_key_pub_us-west-1" {
  provider = "aws.us-west-1"
  key_name   = "honeypot_ec2_key_pub"
  public_key = "${data.local_file.ssh_key_text_pub.content}"
}
