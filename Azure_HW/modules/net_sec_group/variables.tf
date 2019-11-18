variable "azure_region" {}
variable "res_group_name" {}
variable "net_sec_group_name" {}
variable "which_rules" {
	type = list
	default = []
}
variable "predefined_rules" {
  type    = "list"
  default = []
}
# Custom security rules
# [priority, direction, access, protocol, source_port_range, destination_port_range, description]"
# All the fields are required.
variable "custom_rules" {
  description = "Security rules for the network security group using this format name = [priority, direction, access, protocol, source_port_range, destination_port_range, source_address_prefix, destination_address_prefix, description]"
  type        = "list"
  default     = []
}
# source address prefix to be applied to all rules
variable "source_address_prefix" {
  type    = "list"
  default = ["*"]
}
# Destination address prefix to be applied to all rules
variable "destination_address_prefix" {
  type    = "list"
  default = ["*"]
}