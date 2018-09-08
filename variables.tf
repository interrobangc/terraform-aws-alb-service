variable "env" {
  description = "Environment we are running in"
  default     = "default"
}

variable "name" {
  description = "Name for this service"
  default     = "service"
}

variable "ami" {
  description = "AMI for this service"
  default     = "ami-5ccab324"
}

variable "instance_type" {
  description = "Instance Type for this service"
  default     = "t2.nano"
}

variable "key_name" {
  description = "Key name for this service (defaults to ${var.env}_terraform_ec2_key)"
  default     = false
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "instance_security_groups" {
  type        = "list"
  description = "Security groups for instance"
}

variable "alb_security_groups" {
  type        = "list"
  description = "Security groups for elb"
}

variable "service_subnets" {
  type        = "list"
  description = "Subnet ids for instances"
}

variable "alb_subnets" {
  type        = "list"
  description = "Public subnet ids for ALB"
}

variable "min_size" {
  description = "Min Number of instances"
  default     = 1
}

variable "max_size" {
  description = "Max Number of instances"
  default     = 2
}
