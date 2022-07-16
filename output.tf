# Output the private and public IPs of the instance

output "instance_private_ips" {
  value = [oci_core_instance.test_instance.*.private_ip]
}

output "instance_public_ips" {
  value = [oci_core_instance.test_instance.*.public_ip]
}

# Output the boot volume IDs of the instance
output "boot_volume_ids" {
  value = [oci_core_instance.test_instance.*.boot_volume_id]
}

# Output all the devices for all instances
output "instance_devices" {
  value = [data.oci_core_instance_devices.test_instance_devices.*.devices]
}


output "silver_policy_id" {
  value = data.oci_core_volume_backup_policies.test_predefined_volume_backup_policies.volume_backup_policies[0].id
}

/*
output "attachment_instance_id" {
  value = data.oci_core_boot_volume_attachments.test_boot_volume_attachments.*.instance_id
}
*/

