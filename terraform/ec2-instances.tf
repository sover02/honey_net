# Build an EC2 Instance in each region

resource "aws_instance" "HelloWorld-us-east-2" {
  instance_type = "t3.nano"
  provider = "aws.us-east-2"
  ami      = "${data.aws_ami.amazonlinux_latest_us-east-2.id}"
  security_groups = ["${aws_security_group.honeypot_security_group_us-east-2.name}"]
  key_name = "honeypot_ec2_key_pub"

  tags = {
    Name = "HelloWorld-us-east-2"
  }
}

resource "aws_instance" "HelloWorld-us-west-1" {
  instance_type = "t3.nano"
  provider = "aws.us-west-1"
  ami           = "${data.aws_ami.amazonlinux_latest_us-west-1.id}"
  security_groups = ["${aws_security_group.honeypot_security_group_us-west-1.name}"]
  key_name = "honeypot_ec2_key_pub"

  tags = {
    Name = "HelloWorld-us-west-1"
  }

### coming soon to prep for ansible
#  provisioner "file" {
#    source      = "static/wait_for_instance.sh"
#    destination = "/tmp/wait_for_instance.sh"
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#      "chmod +x /tmp/script.sh",
#      "/tmp/wait_for_instance.sh",
#    ]
#  }

}

