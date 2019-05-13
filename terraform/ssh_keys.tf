# Set up ssh key
data "local_file" "ssh_key_text_pub" {
    filename = "${pathexpand("~/.ssh/honeypot_ec2-user.pub")}"
}

resource "aws_key_pair" "honeypot_ec2_key_pub_us-west-1" {
  provider = "aws.us-west-1"
  key_name   = "honeypot_ec2-user"
  public_key = "${data.local_file.ssh_key_text_pub.content}"
}

resource "aws_key_pair" "honeypot_ec2_key_pub_ap-northeast-1" {
  provider = "aws.ap-northeast-1"
  key_name   = "honeypot_ec2-user"
  public_key = "${data.local_file.ssh_key_text_pub.content}"
}

resource "aws_key_pair" "honeypot_ec2_key_pub_ap-eu-north-1" {
  provider = "aws.eu-north-1"
  key_name   = "honeypot_ec2-user"
  public_key = "${data.local_file.ssh_key_text_pub.content}"
}
