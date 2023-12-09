# resource "oci_core_instance" "vm_mng" {
#     # Required
#     availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
#     compartment_id = oci_identity_compartment.tf-compartment.id
#     shape = "VM.Standard.E2.1.Micro"
#     create_vnic_details {
#         #Optional
#         subnet_id = oci_core_subnet.oci_sn_mng.id
#         private_ip = "10.0.1.5"
#         hostname_label = "mng01"
#         display_name = "vm-mng"
#     }
#     source_details {
#         source_id = "Canonical-Ubuntu-20.04-2022.03.02-0"
#         source_type = "image"
#     }
#     # Optional
#     preserve_boot_volume = false
# }
