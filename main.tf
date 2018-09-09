locals {
  default_key_name = "${var.env}_terraform_ec2_key"
}

module "alb" {
  source = "github.com/interrobangc/terraform-aws-alb?ref=v0.1"

  env  = "${var.env}"
  name = "${var.env}-${var.name}"

  vpc_id          = "${var.vpc_id}"
  subnets         = ["${var.alb_subnets}"]
  security_groups = ["${var.alb_security_groups}"]
  logging_enabled = false

  http_tcp_listeners = [
    {
      "port"     = 80
      "protocol" = "HTTP"
    },
  ]

  http_tcp_listeners_count = 1

  target_groups = [
    {
      name             = "${var.env}-${var.name}"
      backend_port     = 80
      backend_protocol = "HTTP"
      vpc_id           = "${var.vpc_id}"
    },
  ]

  target_groups_count = 1
}

module "asg" {
  source = "github.com/interrobangc/terraform-aws-asg?ref=v0.1.1"

  env = "${var.env}"

  # we add the ami to the name to force a redeploy on ami change
  name = "${var.env}-${var.name}-${var.ami}"

  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name ? var.key_name : local.default_key_name}"
  min_size      = "${var.min_size}"
  max_size      = "${var.max_size}"
  subnets       = ["${var.service_subnets}"]

  associate_public_ip_address = "${var.associate_public_ip_address}"

  security_groups = [
    "${module.alb.destination_security_group_ids}",
    "${var.instance_security_groups}",
  ]

  target_group_arns = ["${module.alb.target_group_arns}"]
}

data "aws_instances" "service" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = ["${module.asg.name}"]
  }
}
