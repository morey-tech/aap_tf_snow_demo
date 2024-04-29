variable "access_key" {
    type = string
}

variable "secret_key" {
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

variable "instance_type" {
    type = string
    default = "t2.micro"
}

# below we define the default server names
variable "instance_tags" {
  type = list(string)
  default = ["tf-ansible-1"]
}