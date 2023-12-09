# resource "oci_core_vcn" "oci_vcn" {
#     #Required
#     compartment_id = oci_identity_compartment.tf-compartment.id

#     cidr_blocks    = ["10.0.0.0/16"]
#     display_name   = "oci-vcn"
#     dns_label      = "vnc01"
# }

# resource "oci_core_subnet" "oci_sn_mng" {
#     #Required
#     cidr_block = "10.0.1.0/24"
#     compartment_id = oci_identity_compartment.tf-compartment.id
#     vcn_id = oci_core_vcn.oci_vcn.id

#     #Optional
#     display_name = "oci-sn-mng"
#     dns_label = "subnet01"
# }

# resource "oci_core_subnet" "oci_sn_private" {
#     #Required
#     cidr_block = "10.0.2.0/24"
#     compartment_id = oci_identity_compartment.tf-compartment.id
#     vcn_id = oci_core_vcn.oci_vcn.id

#     #Optional
#     display_name = "oci-sn-private"
#     dns_label = "subnet02"
#     prohibit_public_ip_on_vnic = "true"
# }

# resource "oci_core_subnet" "oci_sn_public" {
#     #Required
#     cidr_block = "10.0.3.0/24"
#     compartment_id = oci_identity_compartment.tf-compartment.id
#     vcn_id = oci_core_vcn.oci_vcn.id

#     #Optional
#     display_name = "oci-sn-public"
#     dns_label = "subnet03"
# }
