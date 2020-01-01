data "aws_region" "current" {
  provider = "aws"
}

data "local_file" "ssh_key_text_pub" {
  filename = "${pathexpand("~/.ssh/honeypot_ec2-user.pub")}"
}

variable "number" {
  default = 1
}

resource "aws_key_pair" "honeypot_ec2_key_pub" {
  provider   = "aws"
  key_name   = "honeypot_ec2-user-${data.aws_region.current.name}"
  public_key = "${data.local_file.ssh_key_text_pub.content}"
}

data "aws_ami" "amazonlinux_latest" {
  provider    = aws
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.????????-x86_64-gp2"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_security_group" "honeypot_security_group" {
  name        = "honeypot_security_group-${data.aws_region.current.name}"
  description = "honey_net rules Allow 22222 for Fake SSH, and 22 for real SSH"
  provider    = "aws"

  # Fake SSH Access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Real SSH Access
  ingress {
    from_port   = 22222
    to_port     = 22222
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All traffic out
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "honey-pot-server" {
  instance_type   = "t3.nano"
  provider        = aws
  ami             = data.aws_ami.amazonlinux_latest.id
  security_groups = [aws_security_group.honeypot_security_group.name]
  key_name        = aws_key_pair.honeypot_ec2_key_pub.key_name
  count           = var.number

  tags = {
    Name    = "honey-net_ap-northeast-1"
    Role    = "ssh_honeypot"
    project = "honey_net"
    trust   = "untrusted"
  }

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo -e \"Waiting for cloud-init...\"; sleep 1; done",
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(pathexpand("~/.ssh/honeypot_ec2-user.pem"))
    agent       = "false"
  }
}

output "public_ip" {
  value = aws_instance.honey-pot-server[*].public_ip
}