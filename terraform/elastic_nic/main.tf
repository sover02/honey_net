variable "number" {
  default = 1
}

variable "subnet" {
  default = ""
}

resource "aws_network_interface" "multi-ip" {
  subnet_id   = "${var.subnet}"
  private_ips_count = 1
}

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = "${element(aws_network_interface.multi-ip.*.id,count.index)}"
  associate_with_private_ip = "10.0.0.10"
  count = "${length(aws_network_interface.multi-ip)}"
}