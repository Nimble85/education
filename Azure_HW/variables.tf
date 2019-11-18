#-------------------------------------------------------
# NetworkModule # --------------------------------------
#-------------------------------------------------------
variable "res_group_name" {
	default = "TrfResourceGroup1"
    description = "Azure resource group name"
}
variable "azure_region" {
	default = "East US"
    description = "Default Amazon region"
}
variable "vnet-name" {
	default = "trf_vnet"
    description = "Default vnet name"
}
variable "address_space" {
	default = "10.0.0.0/16"
    description = "Default CIDR"
}
variable "tags" {
	default = "trf-test-rd"
    description = "Default Amazon VNet name"
}
variable "subnet_name" {
	default = ["subnet1", "subnet2"]
    description = "Default subnet name"
}
variable "subnet_prefix" {
	default = ["10.0.1.0/24", "10.0.2.0/24"]
    description = "Default subnet_prefix"
}
variable "pub_ip_name" {
	default = 	{
		"0" = "pub-ip1"
		"1" = "pub-ip2"
		}	
}
#-------------------------------------------------------
# VM module # ------------------------------------------
#-------------------------------------------------------
variable "on_public_ip" {
	default = "true"
}
variable "count_index" {
	default = "2"
}
variable "nic_name" {
	default = {
		"0" = "trf-nic1"
		"1" = "trf-nic2"
		}	
}
variable "ip_conf_name" {
	default = "trf-ip-conf"
}
variable "vm_name" {
	default = {
		"0" = "trf-vm1"
		"1" = "trf-vm2"
		}
}
#-----------------------------------------------------
## storage disk ## -----------------------------------
#-----------------------------------------------------
variable "disk_name" {
	default = {
		"0" = "trf-disk1"
		"1" = "trf-disk2"
        }
}
variable "disk_cache" {
	default = "ReadWrite"
}
variable "disk_option" {
	default = "FromImage"
}
variable "disk_type" {
	default = "Standard_LRS"
}
#-----------------------------------------------------
## image ## ------------------------------------------
#-----------------------------------------------------
variable "image_publisher" {
	default = "Canonical"
}
variable "image_offer" {
	default = "UbuntuServer"
}
variable "image_sku" {
	default = "16.04.0-LTS"
}
variable "image_version" {
	default = "latest"
}
#-----------------------------------------------------
## os profile ## -------------------------------------
#-----------------------------------------------------
variable "pc_name" {
	default = "trf-pc"
}
variable "user_name" {
	default = "azureuser"
}
variable "user_password" {
	default = "1qa@WS3ed"
}
#-------------------------------------------------------
# NetworkSecurityGroup module #-------------------------
#-------------------------------------------------------
variable "net_sec_group_name" {
	default = "trf-net-sec"
}
variable "custom_rules" {
  description = "Security rules for the network security group using this format name = [priority, direction, access, protocol, source_port_range, destination_port_range, source_address_prefix, destination_address_prefix, description]"
  type        = "list"
  default     = []
}
/*variable "which_rules" {
	type = list
	default = []
}*/