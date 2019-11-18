#-----------------------------------------------------------------------------------
## nic configuration ## ------------------------------------------------------------
#-----------------------------------------------------------------------------------
resource "azurerm_network_interface" "trf-nic" {
	count 				= "${var.count_index}"
    name                = "${lookup(var.nic_name, count.index)}"
    location            = "${var.azure_region}"
    resource_group_name = "${var.res_group_name}"
    
    ip_configuration {
        name                          = "${var.ip_conf_name}"
        subnet_id                     = "${element(var.subnet_id,count.index)}"
        private_ip_address_allocation = "Dynamic"   
		public_ip_address_id 		  = "${var.on_public_ip != "true" ? element(concat(var.pub_ip_id, list("")), count.index) : ""}"
		#"${var.disable_public_ip != "true" ? index(var.pub_ip_id,count.index):""}"
		#"${element(var.pub_ip_id,count.index)}"
    }

    tags = {
        environment = "${var.tags}"
    }
}
#-----------------------------------------------------------------------------------
## vm configuration ## -------------------------------------------------------------
#-----------------------------------------------------------------------------------
resource "azurerm_virtual_machine" "trf-vm" {
	count				  = "${var.count_index}"
    name                  = "${lookup(var.vm_name, count.index)}"
    location              = "${var.azure_region}"
    resource_group_name   = "${var.res_group_name}"
    network_interface_ids = ["${azurerm_network_interface.trf-nic[count.index].id}"]
    vm_size               = "Standard_DS1_v2"
	
    storage_os_disk {
        name              = "${lookup(var.disk_name, count.index)}"
        caching           = "${var.disk_cache}"
        create_option     = "${var.disk_option}"
        managed_disk_type = "${var.disk_type}"
    }

    storage_image_reference {
        publisher = "${var.image_publisher}"
        offer     = "${var.image_offer}"
        sku       = "${var.image_sku}"
        version   = "${var.image_version}"
    }

    os_profile {
        computer_name  = "${var.pc_name}"
        admin_username = "${var.user_name}"
		admin_password = "${var.user_password}"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }
    tags = {
        environment = "${var.tags}"
    }
}