resource "aws_security_group" "honeypot_security_group_us-west-1" {
  name = "honeypot_security_group-us-west-1"
  description = "allow ssh"
  provider = "aws.us-west-1"

  # SSH Access
  ingress {
    from_port = 0
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "honeypot_security_group_us-east-2" {
  name = "honeypot_security_group-us-east-2"
  description = "allow ssh"
  provider = "aws.us-east-2"

  # SSH Access
  ingress {
    from_port = 0
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
