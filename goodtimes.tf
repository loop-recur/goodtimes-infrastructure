resource "aws_security_group" "goodtimes" {
  name = "bot_server"
  description = "The goodtimes scheduler, inquisitor, and wiggum"
  vpc_id = "${module.core_vpc.id}"

  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/0"]
  }
}

resource "aws_instance" "goodtimes" {
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  subnet_id = "${module.core_vpc.public_subnet_id}"

  ami = "${var.goodtimes_ami}"
  security_groups = ["${module.core_vpc.sg_public_ssh_id}"
                    ,"${aws_security_group.goodtimes.id}"]

  connection {
    user = "ec2-user"
    key_file = "~/.ssh/terraform.pem"
  }
}

resource "aws_route53_zone" "primary" {
  name = "goodtimesbot.com"
}

resource "aws_route53_record" "goodtimes" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name = "goodtimesbot.com"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.goodtimes.public_ip}"]
}
