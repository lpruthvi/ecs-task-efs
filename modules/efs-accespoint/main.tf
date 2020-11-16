resource "aws_efs_access_point" "main" {
  count = var.efs_enable ? 1 : 0
  file_system_id = element(var.aws_efs_file_system_id, count.index)
}