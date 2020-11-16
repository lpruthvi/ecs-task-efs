variable "efs_subnet_id" {
}
variable "vpc_public_subnets" {
}
variable "efs_enable" {
    default = false
    description = "(optional) describe your variable"
}
variable "efs_security_group" {
    default = " "
    description = "Secuirt group for EFS"
}
variable "efs_name" {
    default = " "
    description = "Pass ENV from Main file"
}