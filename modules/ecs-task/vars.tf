variable "task_role_arn" {
   default = " "
}
variable "ecs_task_name" {
   default = " "
}
variable "file_task_definition" {
   default = " "
}
variable "efs_id" {
   default = " "
}
variable "ecs_volume_name" {
   default = " "
}
variable "ecs_network_mode" {
   default = " "
}
variable "aws_efs_access_point_id" {
   default = " "
}
variable "efs_enable" {
   default = false
   description = "Enable efs from Main Application file if required"
}