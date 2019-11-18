# This module configure and deploy a ResourceGroup, VirtualNetwork and Subnet 
# and PublicIP according to HW
#----------------------------------------------------------------------------
# RecourceGroup Configuration #----------------------------------------------
#----------------------------------------------------------------------------
resource "azurerm_resource_group" "trf-rg" {
	name     = "${var.res_group_name}"
    location = "${var.azure_region}"
}
#----------------------------------------------------------------------------
# VNet Configuration #-------------------------------------------------------
#----------------------------------------------------------------------------
resource "azurerm_virtual_network" "trf-vnet" {
  name                = "${var.vnet-name}" 
  location            = "${azurerm_resource_group.trf-rg.location}"
  resource_group_name = "${azurerm_resource_group.trf-rg.name}"
  address_space       = ["${var.address_space}"]
  tags = {
    environment = "${var.tags}"
  }
}
#----------------------------------------------------------------------------
# Subnet Configuration #-----------------------------------------------------
#----------------------------------------------------------------------------
resource "azurerm_subnet" "trf-subnets" {
  count				   = "${var.count_index}"
  name                 = "${element(var.subnet_name,count.index)}"
  resource_group_name  = "${azurerm_resource_group.trf-rg.name}"
  virtual_network_name = "${azurerm_virtual_network.trf-vnet.name}"
  address_prefix       = "${element(var.subnet_prefix,count.index)}"
  network_security_group_id = "${var.net_sec_group_id}"
}
#----------------------------------------------------------------------------
# Public IP Configuration #--------------------------------------------------
#----------------------------------------------------------------------------
resource "azurerm_public_ip" "trf-pub-ip" {
  count				  = "${var.on_public_ip ? 2 : 0}"	
  name                = "${lookup(var.pub_ip_name, count.index)}"
  location            = "${azurerm_resource_group.trf-rg.location}"
  resource_group_name = "${azurerm_resource_group.trf-rg.name}"
  allocation_method   = "Dynamic"

  tags = {
    environment = "${var.tags}"
  }
}

