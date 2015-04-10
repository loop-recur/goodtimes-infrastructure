variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "region" {
  default="us-west-1"
}

variable "grafana_ami" {}
variable "consul_ami" {}
variable "influx_ami" {}
variable "statsd_ami" {}
variable "goodtimes_ami" {}

variable "goodtimes_db_host" {}
variable "goodtimes_db_name" {}
variable "goodtimes_db_user" {}
variable "goodtimes_db_pass" {}

variable "domain_name" {}

variable "slack_app_id" {}
variable "slack_secret" {}

variable "key_name" {
  description = "Name of the keypair to use in EC2."
  default = ""
}
