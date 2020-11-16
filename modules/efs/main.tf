resource "aws_efs_file_system" "efs" {
  count = var.efs_enable ? 1 : 0
  performance_mode = "generalPurpose"
  encrypted        = true
  tags = {
    Name = "${var.efs_name}_efs"
    env = var.efs_name
    provider = "Terraform"
  }
}

resource "aws_efs_mount_target" "mount" {
  count = var.efs_enable ? length(var.vpc_public_subnets) : 0
  file_system_id = element(aws_efs_file_system.efs.*.id, count.index)
  subnet_id      = element(var.efs_subnet_id, count.index)
  security_groups = var.efs_security_group
}