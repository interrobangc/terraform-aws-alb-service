output "service_private_ips" {
  value = "${data.aws_instances.service.private_ips}"
}

output "service_public_ips" {
  value = "${data.aws_instances.service.public_ips}"
}

output "hostname" {
  value = "${module.alb.dns_name}"
}
