# Get latest AMI image from each region
data "aws_ami" "amazonlinux_latest_us-east-1" {
  provider = "aws.us-east-1"
  most_recent = true
  filter { name = "owner-alias", values = ["amazon"] }
  filter { name = "name", values = ["amzn2-ami-hvm*"] }
  filter { name = "architecture", values = ["x86_64*"] }
}

data "aws_ami" "amazonlinux_latest_ap-northeast-1" {
  provider = "aws.ap-northeast-1"
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
