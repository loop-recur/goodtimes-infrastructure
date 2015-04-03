resource "aws_security_group" "goodtimes" {
  name = "bot_server"
  description = "The goodtimes scheduler, inquisitor, and wiggum"
  vpc_id = "${module.core_vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/0"]
  }
}

resource "aws_instance" "goodtimes" {
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  subnet_id = "${module.core_vpc.public_subnet_id}"

  ami = "${var.goodtimes_ami}"
  security_groups = ["${aws_security_group.goodtimes.id}"]

  connection {
    user = "ec2-user"
    key_file = "~/.ssh/terraform.pem"
  }
}

resource "aws_route53_zone" "production" {
  name = "goodtimesbot.com"
}

resource "aws_route53_record" "goodtimes-production" {
  zone_id = "${aws_route53_zone.production.zone_id}"
  name = "goodtimesbot.com"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.goodtimes.public_ip}"]
}

resource "aws_route53_record" "goodtimes-production-subdomains" {
  zone_id = "${aws_route53_zone.production.zone_id}"
  name = "*.goodtimesbot.com"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.goodtimes.public_ip}"]
}
