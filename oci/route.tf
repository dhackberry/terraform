#resource "oci_core_internet_gateway" "CompleteIG" {
#  compartment_id = "${var.compartment_ocid}"
#  display_name   = "CompleteIG"
#  vcn_id         = "${oci_core_virtual_network.CompleteVCN.id}"
#}
#
#resource "oci_core_route_table" "RouteForComplete" {
#  compartment_id = "${var.compartment_ocid}"
#  vcn_id         = "${oci_core_virtual_network.CompleteVCN.id}"
#  display_name   = "RouteTableForComplete"
#
#  route_rules {
#    destination        = "0.0.0.0/0"
#    network_entity_id = "${oci_core_internet_gateway.CompleteIG.id}"
#  }
#}
