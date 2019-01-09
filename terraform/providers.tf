
# Establish multiple region providers
provider "aws" { } # Need a base to build on top of
provider "aws" { alias = "us-east-2", region = "us-east-2" }
provider "aws" { alias = "us-west-1", region = "us-west-1" }




# Get latest AMI image from each region
data "aws_ami" "amazonlinux_useast2_latest" {
  provider = "aws.us-east-2"
  most_recent = true

  filter { name = "owner-alias", values = ["amazon"] }
  filter { name = "name", values = ["amzn2-ami-hvm*"] }
}

data "aws_ami" "amazonlinux_uswest1_latest" {
  provider = "aws.us-west-1"
  most_recent = true

  filter { name = "owner-alias", values = ["amazon"] }
  filter { name   = "name", values = ["amzn2-ami-hvm*"] }
}
