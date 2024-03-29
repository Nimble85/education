#------------------------------------------------------------------------------
# Azurerm Network Security Group and Rule #------------------------------------
#------------------------------------------------------------------------------
## security_group ##-----------------------------------------------------------
#------------------------------------------------------------------------------
resource "azurerm_network_security_group" "trf-sg" {
  name                = "${var.net_sec_group_name}"
  location            = "${var.azure_region}"
  resource_group_name = "${var.res_group_name}"
}
#------------------------------------------------------------------------------
## security_rule ##------------------------------------------------------------
### predefined_rules ###-------------------------------------------------------
#------------------------------------------------------------------------------
resource "azurerm_network_security_rule" "predefined_rules" {
  count                       = "${length(var.predefined_rules)}"
  name                        = "${lookup(var.predefined_rules[count.index], "name")}"
  priority                    = "${lookup(var.predefined_rules[count.index], "priority", "${4096 - length(var.predefined_rules) + count.index }" )}"
  direction                   = "${element(var.rules["${lookup(var.predefined_rules[count.index], "name")}"], 0)}"
  access                      = "${element(var.rules["${lookup(var.predefined_rules[count.index], "name")}"], 1)}"
  protocol                    = "${element(var.rules["${lookup(var.predefined_rules[count.index], "name")}"], 2)}"
  source_port_ranges          = "${split(",", replace(  "${lookup(var.predefined_rules[count.index], "source_port_range", "*" )}"  ,  "*" , "0-65535" ) )}"
  destination_port_range      = "${element(var.rules["${lookup(var.predefined_rules[count.index], "name")}"], 4)}"
  description                 = "${element(var.rules["${lookup(var.predefined_rules[count.index], "name")}"], 5)}"
  source_address_prefix       = "${join(",", var.source_address_prefix)}"
  destination_address_prefix  = "${join(",", var.destination_address_prefix)}"
  resource_group_name         = "${var.res_group_name}"
  network_security_group_name = "${azurerm_network_security_group.trf-sg.name}"
}
### custom_rules ###-----------------------------------------------------------
#------------------------------------------------------------------------------
resource "azurerm_network_security_rule" "custom_rules" {
  count                       = "${length(var.custom_rules)}"
  name                        = "${lookup(var.custom_rules[count.index], "name", "default_rule_name")}"
  priority                    = "${lookup(var.custom_rules[count.index], "priority")}"
  direction                   = "${lookup(var.custom_rules[count.index], "direction", "Any")}"
  access                      = "${lookup(var.custom_rules[count.index], "access", "Allow")}"
  protocol                    = "${lookup(var.custom_rules[count.index], "protocol", "*")}"
  source_port_ranges          = "${split(",", replace(  "${lookup(var.custom_rules[count.index], "source_port_range", "*" )}"  ,  "*" , "0-65535" ) )}"
  destination_port_ranges     = "${split(",", replace(  "${lookup(var.custom_rules[count.index], "destination_port_range", "*" )}"  ,  "*" , "0-65535" ) )}"
  source_address_prefix       = "${lookup(var.custom_rules[count.index], "source_address_prefix", "*")}"
  destination_address_prefix  = "${lookup(var.custom_rules[count.index], "destination_address_prefix", "*")}"
  description                 = "${lookup(var.custom_rules[count.index], "description", "Security rule for ${lookup(var.custom_rules[count.index], "name", "default_rule_name")}")}"
  resource_group_name         = "${var.res_group_name}"
  network_security_group_name = "${azurerm_network_security_group.trf-sg.name}"
}