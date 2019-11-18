# NetworkInterface # --------------------------
variable "nic_name" {}
variable "azure_region" {}
variable "res_group_name" {}
variable "ip_conf_name" {}
variable "subnet_id" {}
variable "pub_ip_id" {}
variable "tags" {}
#
# VirtualMachine # ----------------------------
variable "count_index" {}
variable "vm_name" {}
#
## storage disk ## ----------------------------
variable "disk_name" {}
variable "disk_cache" {}
variable "disk_option" {}
variable "disk_type" {}
#
## image ## ------------------------------
variable "image_publisher" {}
variable "image_offer" {}
variable "image_sku" {}
variable "image_version" {}
#
## os profile ## ------------------------------
variable "pc_name" {}
variable "user_name" {}
variable "user_password" {}
variable "on_public_ip" {}