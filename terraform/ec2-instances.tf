# Build an EC2 Instance in each region

resource "aws_instance" "HelloWorld-us-east-2" {
  instance_type = "t3.nano"
  provider = "aws.us-east-2"
  ami      = "${data.aws_ami.amazonlinux_useast2_latest.id}"

  tags = {
    Name = "HelloWorld-us-east-2"
  }
}

resource "aws_instance" "HelloWorld-us-west-1" {
  ami           = "${data.aws_ami.amazonlinux_uswest1_latest.id}"
  instance_type = "t3.nano"
  provider = "aws.us-west-1"

  tags = {
    Name = "HelloWorld-us-west-1"
  }
}

