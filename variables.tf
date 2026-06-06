variable "ami_ubuntu_latest" {
  description = "AMI ID of the latest Ubuntu release"
  type        = string
  default     = "ami-0d13e2317a7e75c95"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "ssh_ipv4" {
  description = "The IPv4 address/CIDR block allowed to SSH into the instance"
  type = string
}
