# turn on (true) or off (false) public ip
on_public_ip = "false"

# use defaulte or custome net sec rule
custom_rules = [
	{
		name                        = "$SSH"
		priority                    = "100"
		direction                   = "Inbound"
		access                      = "Allow"
		protocol                    = "TCP"
		source_port_range           = "*"
		destination_port_range      = "22"
		source_address_prefix       = "*"
		destination_address_prefix  = "*"
		description 				= "some description"
	}
]