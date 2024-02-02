# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "instance_size" {
  type        = string
  description = "instance size"
}

variable "name" {
  type        = string
  description = "name of the instance - avoids guardrails ticket and lets us know what it is"
}

variable "key" {
  type        = string
  description = "ssh key to use for ssh access"
}

variable "profile" {
  type        = string
  description = "aws profile to use"
}

variable "server_port" {
  type        = number
  description = "any variable you want to pass to the bash script"
  default     = 8000
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "volume_size" {
  description = "The size of the root volume in GB"
  type        = number
  default     = 100
}

variable "install_librenms" {
  type    = bool
  description = "If true this will run a script to install LibreNMS on ubuntu 22.04, with no database (use external one)"
  default = false
}

variable "bash_script" {
  type        = string
  description = "bash script to run on the instance"
  default     = null
}

variable "region" {
  type        = string
  description = "aws region"
  default     = "us-west-2"
}

variable "cidr_blocks" {
  type        = list(string)
  description = "All internal ip's minus the micro env at 192.168/16"
  default     = ["172.16.0.0/12", "10.0.0.0/8"]
}

variable "az" {
  type        = string
  description = "availability zone, e.g. a, b, c"
  default     = "a"
}

variable "tcp_allowed_ports_in" {
  description = "List of allowed ports"
  type        = list(number)
  default     = [161, 162, 80, 443, 8000, 22, 3306] #common set of ports we would need
}

variable "udp_allowed_ports_in" {
  description = "List of allowed ports"
  type        = list(number)
  default     = [161, 162] #common set of ports we would need
}