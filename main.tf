
data "template_file" "user_data" {
  template = base64encode(file("./sw.sh"))
}



resource "oci_core_instance" "test_instance" {
  count               = var.num_instances
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "TestInstance${count.index}"
  shape               = var.instance_shape

  create_vnic_details {
    subnet_id                 = oci_core_subnet.test_subnet.id
    display_name              = "Primaryvnic"
    assign_public_ip          = true
    assign_private_dns_record = true
    hostname_label            = "exampleinstance${count.index}"
  }

  source_details {
    source_type = "image"
    source_id = var.instance_image_ocid[var.region]
  }


  metadata = {
    ssh_authorized_keys = var.ssh_public_key
   # user_data	= " base64encode${file("sw.sh")}"
   ## user_data  =  base64encode(file("./sw.sh"))
   user_data     = data.template_file.user_data.rendered
  }

  freeform_tags = {
    "freeformkey${count.index}" = "freeformvalue${count.index}"
  }


  timeouts {
    create = "60m"
  }
}

# Define the volumes that are attached to the compute instances.

resource "oci_core_volume" "test_block_volume_paravirtualized" {
  count               = var.num_instances * var.num_paravirtualized_volumes_per_instance
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "TestBlockParavirtualized${count.index}"
  size_in_gbs         = var.db_size
}

resource "oci_core_volume_attachment" "test_block_volume_attach_paravirtualized" {
  count           = var.num_instances * var.num_paravirtualized_volumes_per_instance
  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.test_instance[floor(count.index / var.num_paravirtualized_volumes_per_instance)].id
  volume_id       = oci_core_volume.test_block_volume_paravirtualized[count.index].id
}

resource "oci_core_volume_backup_policy_assignment" "policy" {
  count     = var.num_instances
  asset_id  = oci_core_instance.test_instance[count.index].boot_volume_id
  policy_id = data.oci_core_volume_backup_policies.test_predefined_volume_backup_policies.volume_backup_policies[0].id
}

resource "null_resource" "remote-exec" {
  depends_on = [
    oci_core_instance.test_instance,
  ]
  count = var.num_instances * var.num_paravirtualized_volumes_per_instance

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = oci_core_instance.test_instance[count.index % var.num_instances].public_ip
      user        = "opc"
      private_key = file("${path.module}/key.txt") 
    }
inline = [
   "touch ~/test_file",
   "sudo useradd test",
]

  }
}

/*
# Gets the boot volume attachments for each instance
data "oci_core_boot_volume_attachments" "test_boot_volume_attachments" {
  depends_on          = [oci_core_instance.test_instance]
  count               = var.num_instances
  availability_domain = oci_core_instance.test_instance[count.index].availability_domain
  compartment_id      = var.compartment_ocid
  instance_id = oci_core_instance.test_instance[count.index].id
}
*/

data "oci_core_instance_devices" "test_instance_devices" {
  count       = var.num_instances
  instance_id = oci_core_instance.test_instance[count.index].id
}

data "oci_core_volume_backup_policies" "test_predefined_volume_backup_policies" {
  filter {
    name = "display_name"

    values = [
      "silver",
    ]
  }
}

