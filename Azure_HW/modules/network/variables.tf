# Resource group  #------------------------------------
variable "res_group_name" {}
variable "azure_region" {}
#
# VNet #-----------------------------------------------
variable "vnet-name" {}
variable "address_space" {}
variable "tags" {}
#
# Subnet #---------------------------------------------
variable "subnet_name" {}
variable "subnet_prefix" {}
variable "net_sec_group_id" {}
# pub ip #---------------------------------------------
variable "count_index" {}
variable "pub_ip_name" {}
variable "on_public_ip" {}


