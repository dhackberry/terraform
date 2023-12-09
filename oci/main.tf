terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.72.0"
    }
  }
  # backend "http" {}
  cloud {
    organization = "eno-oci"
    workspaces {
      name = "prd"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

resource "oci_identity_compartment" "tf-compartment" {
  # Required
  compartment_id = var.tenancy_ocid
  description    = "Compartment for Terraform resources."
  name           = "oci-dev"
}

data "oci_identity_availability_domains" "ads" {
  provider       = oci
  compartment_id = oci_identity_compartment.tf-compartment.id
}
