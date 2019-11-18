output "private_ip" {
	value = "${azurerm_network_interface.trf-nic.*.private_ip_address}"
}
