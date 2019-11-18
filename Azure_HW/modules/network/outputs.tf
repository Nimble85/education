output "res_group_name" {
	value = "${azurerm_resource_group.trf-rg.name}"
}
output "res_group_location" {
	value = "${azurerm_resource_group.trf-rg.location}"
}
output "subnet_id" {
	value = "${azurerm_subnet.trf-subnets.*.id}"
}
output "pub_ip_id" {
	value = "${azurerm_public_ip.trf-pub-ip.*.id}"
}
/*output "pub_ip_address" {
    value = "${data.azurerm_public_ip.trf-pub-ip.*.ip_address}"
}*/
