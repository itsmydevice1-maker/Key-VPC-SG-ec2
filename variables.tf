# root volume of an ec2 instance

variable "default_root_volume_size" {
  description = "The default size of the root storage volume in gigs"
  type        = number
  default     = 10
}

# ec2 instance volume_type

variable "root_volume_type" {
  description = "The type of volume to use for root storage"
  type        = string
  default     = "gp3"
}

variable "env" {
  default = "prd"
  type    = string
}