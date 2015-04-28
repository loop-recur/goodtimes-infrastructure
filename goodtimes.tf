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
  vpc_id = "${module.core_vpc.id}"

  ami = "${var.goodtimes_ami}"
  security_groups = ["${aws_security_group.goodtimes.id}"]

  connection {
    user = "ec2-user"
    key_file = "~/.ssh/terraform.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh -c 'echo \"/app/bin/postgrest --db-host ${var.goodtimes_db_host} --db-port 5432 --db-name ${var.goodtimes_db_name} --db-user ${var.goodtimes_db_user} --db-pass ${var.goodtimes_db_pass} --db-pool 67 --anonymous ${var.goodtimes_db_user} --port 8000 2>&1 | logger -t postgrest &\" >> /etc/rc.local'",
      "sudo sh -c 'echo -e \"#!/bin/sh\n/app/bin/scheduler\n\" > /etc/cron.daily/scheduler'",
      "sudo chmod a+x /etc/cron.daily/scheduler",
      "sudo sh -c 'echo \"* * * * 1,2,3,4,5 ec2-user /app/bin/inquisitor\" > /etc/crontab'",

      "curl -X PUT -d '{\"db_address\":\"http://localhost:8000\",\"slack_secret\":\"${var.slack_secret}\",  \"slack_app_id\": \"${var.slack_app_id}\", \"public_host\": \"http://${var.domain_name}\"}' http://127.0.0.1:8500/v1/kv/gt.wiggum.config",
      "curl -X PUT -d '{\"host\":\"${var.goodtimes_db_host}\", \"port\":5432, \"user\": \"${var.goodtimes_db_user}\", \"pw\": \"${var.goodtimes_db_pass}\", \"db\": \"${var.goodtimes_db_name}\"}' http://127.0.0.1:8500/v1/kv/gt.postgres",
      "curl -X PUT -d '{\"connections\": 1, \"expire_time\": 600}' http://127.0.0.1:8500/v1/kv/gt.postgres.pool"
    ]
  }
}

resource "aws_route53_zone" "production" {
  name = "${var.domain_name}"
}

resource "aws_route53_record" "goodtimes-production" {
  zone_id = "${aws_route53_zone.production.zone_id}"
  name = "${var.domain_name}"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.goodtimes.public_ip}"]
}

resource "aws_route53_record" "goodtimes-production-subdomains" {
  zone_id = "${aws_route53_zone.production.zone_id}"
  name = "*.${var.domain_name}"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.goodtimes.public_ip}"]
}

resource "aws_route53_record" "goodtimes-support_email" {
  zone_id = "${aws_route53_zone.production.zone_id}"
  name = "${var.domain_name}"
  type = "MX"
  ttl = "300"
  records = ["10 mx.hover.com.cust.hostedemail.com"]
}
