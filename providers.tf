provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}



terraform {
  required_providers {
 ocias = {
      source  = "oracle/oci"
##source = "registry.terraform.io/hashicorp/oci"
      version = "= 4.79.0"
    }
  }
  required_version = ">= 0.13"
}

