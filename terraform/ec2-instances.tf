# Build an EC2 Instance in each region

resource "aws_instance" "honey-net_ap-northeast-1" {
  instance_type = "t3.nano"
  provider = "aws.ap-northeast-1"
  ami      = "${data.aws_ami.amazonlinux_latest_ap-northeast-1.id}"
  security_groups = ["${aws_security_group.honeypot_security_group_ap-northeast-1.name}"]
  key_name = "honeypot_ec2_key_pub"
  iam_instance_profile = "honey_net-untrusted-logging_role"

  tags = {
    Name = "honey-net_ap-northeast-1",
    Role = "ssh_honeypot",
    project = "honey_net",
    trust = "untrusted"
  }

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo -e \"Waiting for cloud-init...\"; sleep 1; done",
    ]
  }

  connection {
    user = "ec2-user"
    private_key = "${file(pathexpand("~/.ssh/honeypot_ec2-instance_id_rsa"))}"
    agent = "false"
  }
}

resource "aws_instance" "honey-net_us-west-1" {
  instance_type = "t3.nano"
  provider = "aws.us-west-1"
  ami           = "${data.aws_ami.amazonlinux_latest_us-west-1.id}"
  security_groups = ["${aws_security_group.honeypot_security_group_us-west-1.name}"]
  key_name = "honeypot_ec2_key_pub"
  iam_instance_profile = "honey_net-untrusted-logging_role"

  tags = {
    Name = "honey-net_us-west-1",
    Role = "ssh_honeypot",
    project = "honey_net",
    trust = "untrusted"
  }

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo -e \"Waiting for cloud-init...\"; sleep 1; done",
    ]
  }

  connection {
    user = "ec2-user"
    private_key = "${file(pathexpand("~/.ssh/honeypot_ec2-instance_id_rsa"))}"
    agent = "false"
  }

}

resource "aws_instance" "honey-net_eu-north-1" {
  instance_type = "t3.nano"
  provider = "aws.eu-north-1"
  ami           = "${data.aws_ami.amazonlinux_latest_eu-north-1.id}"
  security_groups = ["${aws_security_group.honeypot_security_group_eu-north-1.name}"]
  key_name = "honeypot_ec2_key_pub"
  iam_instance_profile = "honey_net-untrusted-logging_role"

  tags = {
    Name = "honey-net_us-eu-north-1",
    Role = "ssh_honeypot",
    project = "honey_net",
    trust = "untrusted"
  }

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo -e \"Waiting for cloud-init...\"; sleep 1; done",
    ]
  }

  connection {
    user = "ec2-user"
    private_key = "${file(pathexpand("~/.ssh/honeypot_ec2-instance_id_rsa"))}"
    agent = "false"
  }

}

