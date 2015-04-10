provider "aws" {
  region = "${var.region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

module "core_vpc" {
  source = "github.com/begriffs/microservice-template//terraform/modules/core_vpc"

  key_name = "${var.key_name}"
  consul_ami = "${var.consul_ami}"
}

module "monitoring" {
  source = "github.com/begriffs/microservice-template//terraform/modules/monitoring"

  vpc_id = "${module.core_vpc.id}"
  key_name = "${var.key_name}"

  grafana_ami = "${var.grafana_ami}"
  influx_ami = "${var.influx_ami}"

  sg_consul_id = "${module.core_vpc.sg_consul_id}"
  sg_ssh_id = "${module.core_vpc.sg_ssh_id}"
  sg_public_ssh_id = "${module.core_vpc.sg_public_ssh_id}"
  subnet_id = "${module.core_vpc.public_subnet_id}"
}

module "statsd" {
  source = "github.com/begriffs/microservice-template//terraform/modules/statsd"

  key_name = "${var.key_name}"
  statsd_ami = "${var.statsd_ami}"
  sg_consul_id = "${module.core_vpc.sg_consul_id}"
  vpc_id = "${module.core_vpc.id}"
  subnet_id = "${module.core_vpc.private_subnet_id}"
}
