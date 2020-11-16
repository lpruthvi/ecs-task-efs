output "aws_efs_access_point_id" {
    value = aws_efs_access_point.main.*.id
}