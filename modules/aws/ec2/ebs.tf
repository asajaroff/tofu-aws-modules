# Create a local map for EBS volume configurations
locals {
  ebs_volumes = {
    for pair in flatten([
      for instance in var.instances : [
        for vol_idx, vol in var.additional_ebs_volumes : {
          key                   = "${instance.name}-vol${vol_idx}"
          instance_key          = instance.name
          vol_idx               = vol_idx
          volume_size           = vol.volume_size
          volume_type           = vol.volume_type
          iops                  = vol.iops
          throughput            = vol.throughput
          encrypted             = vol.encrypted
          kms_key_id            = vol.kms_key_id
          device_name           = vol.device_name
          mount_point           = vol.mount_point
          filesystem_type       = vol.filesystem_type
          delete_on_termination = vol.delete_on_termination
        }
      ]
    ]) : pair.key => pair
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume
# Create additional EBS volumes for each instance
resource "aws_ebs_volume" "additional" {
  for_each = local.ebs_volumes

  availability_zone = data.aws_subnet.selected.availability_zone
  size              = each.value.volume_size
  type              = each.value.volume_type
  iops              = each.value.iops
  throughput        = each.value.throughput
  encrypted         = each.value.encrypted
  kms_key_id        = each.value.kms_key_id

  tags = merge(
    {
      Name = "${each.value.instance_key}-${replace(each.value.mount_point, "/", "-")}"
    },
    var.tags
  )
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment
# Attach volumes to instances
resource "aws_volume_attachment" "additional" {
  for_each = local.ebs_volumes

  device_name  = each.value.device_name
  volume_id    = aws_ebs_volume.additional[each.key].id
  instance_id  = aws_instance.this[each.value.instance_key].id
  force_detach = true
}
