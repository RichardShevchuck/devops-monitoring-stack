variable "security_group_id" {
  description = "Security group for EC2 instance"
  type        = string
}


variable "subnet_id" {
  description = "Subnet for EC2 instance"
  type        = string
}


variable "key_name" {
  description = "Key pair name for EC2 instance"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
