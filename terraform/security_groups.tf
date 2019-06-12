resource "aws_security_group" "honeypot_security_group_us-west-1" {
  name        = "honeypot_security_group-us-west-1"
  description = "honey_net rules Allow 22222 for Fake SSH, and 22 for real SSH"
  provider    = "aws.us-west-1"

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

resource "aws_security_group" "honeypot_security_group_ap-northeast-1" {
  name        = "honeypot_security_group-ap-northeast-1"
  description = "honey_net rules Allow 22222 for Fake SSH, and 22 for real SSH"
  provider    = "aws.ap-northeast-1"

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

resource "aws_security_group" "honeypot_security_group_eu-north-1" {
  name        = "honeypot_security_group-eu-north-1"
  description = "honey_net rules Allow 22222 for Fake SSH, and 22 for real SSH"
  provider    = "aws.eu-north-1"

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
