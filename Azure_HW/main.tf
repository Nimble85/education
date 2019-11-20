# The main confoguration of Azure infrastructure
#--------------------------------------------------------------------
# Azure Provider Configure #-----------------------------------------
#--------------------------------------------------------------------
provider "azurerm" {
	subscription_id = "${subscription_id}"
        client_id 	= "${client_id}"
        client_secret	= "${client_secret}"
        tenant_id 	= "${tenant_id}"
}
#--------------------------------------------------------------------
# Network Module #---------------------------------------------------
#--------------------------------------------------------------------
  module "network" {
    source			= "./modules/network"
	res_group_name 		= "${var.res_group_name}"
	azure_region 		= "${var.azure_region}"
	vnet-name 		= "${var.vnet-name}"
	address_space 		= "${var.address_space}"
	tags 			= "${var.tags}"
	subnet_name 		= "${var.subnet_name}"
	subnet_prefix 		= "${var.subnet_prefix}"
	pub_ip_name 		= "${var.pub_ip_name}"
	count_index 		= "${var.count_index}"
	on_public_ip   		= "${var.on_public_ip}"
	net_sec_group_id 	= "${module.net_sec_group.net_sec_group_id}"
}
#--------------------------------------------------------------------
# VM Module # -------------------------------------------------------
#--------------------------------------------------------------------
  module "vm" {
    source 				= "./modules/vm"
	#---------------------------------------------------
	## network_interface ## ----------------------------
	nic_name		= "${var.nic_name}"
	ip_conf_name		= "${var.ip_conf_name}"
	res_group_name 		= "${module.network.res_group_name}"
	azure_region 		= "${module.network.res_group_location}"
	subnet_id		= "${module.network.subnet_id}"
	pub_ip_id		= "${module.network.pub_ip_id}"
	on_public_ip   		= "${var.on_public_ip}"
	#--------------------------------------------------
	## vm ## ------------------------------------------ 
	count_index 		= "${var.count_index}"
	vm_name			= "${var.vm_name}"
	#--------------------------------------------------
	## storage_disk ## --------------------------------
	disk_name		= "${var.disk_name}"
	disk_cache		= "${var.disk_cache}"
	disk_option		= "${var.disk_option}"
	disk_type		= "${var.disk_type}"
	#--------------------------------------------------
	## image ## ---------------------------------------
	image_publisher		= "${var.image_publisher}"
	image_offer		= "${var.image_offer}"
	image_sku 		= "${var.image_sku}"
	image_version		= "${var.image_version}"
	#--------------------------------------------------
	## os_profile ## ----------------------------------
	pc_name			= "${var.pc_name}"
	user_name		= "${var.user_name}"
	user_password		= "${var.user_password}"
	tags 			= "${var.tags}"
}
#----------------------------------------------------------------------
# NetworkSecurityGroup module #----------------------------------------
#----------------------------------------------------------------------
  module "net_sec_group" {
    source 			= "./modules/net_sec_group"
	net_sec_group_name   	= "${var.net_sec_group_name}"
	azure_region 		= "${module.network.res_group_location}"
	res_group_name       	= "${module.network.res_group_name}"
}
#----------------------------------------------------------------------
# Outputs #------------------------------------------------------------
#----------------------------------------------------------------------
output "res_group_name_out" {
	value = "${module.network.res_group_name}"
}
/*
output "pub_ip_address" {
    value = "${module.network.pub_ip_address}"
}
*/
output "private_ip" {
	value = "${module.vm.private_ip}"
}
