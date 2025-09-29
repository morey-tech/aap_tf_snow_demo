variable "webserver_count" {
  type = number
  default = 1
}

variable "access_key" {
    type = string
}

variable "secret_key" {
    type = string
}

variable "instance_name_lb" {
  type = string
}

variable "instance_name_webserver" {
  type = string
}

variable "project_name" {
  type = string
}

variable "network_interface_id" {
  type = string
  default = "network_id_from_aws"
}

variable "ami" {
    type = string
    default = "ami-0d77c9d87c7e619f9"
}

variable "key_instance_name" {
  type = string
  default = "ansible_terraform_demo"
}
