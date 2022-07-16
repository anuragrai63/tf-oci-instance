variable "tenancy_ocid" {
type = string 
description = "Tenancy OCID"

}

variable "user_ocid" {
type = string
description = "User OCID"
}

variable "fingerprint" {
type = string
description = " Fingerprint "
}

variable "private_key_path" {
type = string
description = "Private Key"
}

variable "region" {
type = string
description = " Region "
}

variable "compartment_ocid" {
type = string
description = "Compartment"
}

variable "ssh_public_key" {
type = string
description = "SSH Public  Key"
}

variable "ssh_private_key" {
type = string
description = "SSH Private Key"
}

variable "num_instances" {
  default = "1"
}

variable "num_paravirtualized_volumes_per_instance" {
  default = "1"
}

variable "instance_shape" {
  default = "VM.Standard.E2.1.Micro"
}

variable "instance_image_ocid" {
  type = map(string)
 default = {

    ap-mumbai-1   = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaa2g4i6mvicukkzhacy75fu7np2h2heqrfe4safhjm62hm2ys52mxq"
    ap-hyderabad-1   = "ocid1.image.oc1.ap-hyderabad-1.aaaaaaaacpgru3auow3p7elgvwoow37x5min5lutjribez4yhebajwmz6pna"
  }
}
variable "db_size" {
  default = "50" # size in GBs
}

variable "tag_namespace_description" {
  default = "Just a test"
}

variable "tag_namespace_name" {
  default = "testexamples-tag-namespace"
}
