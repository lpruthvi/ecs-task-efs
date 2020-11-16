variable "AWS_REGION" {
  type = map(string)
  description = "AWS_REGION"
  default = {
    dev = "us-east-2"
    uat = "us-east-2"
  }
}

##### Network #########
variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = map(string)
  default     = {
      dev   = "10.0.0.0/16"
      uat   = "192.168.0.0/16"
  }
}

variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type        = map(list(string))
 default     = {
      dev = ["10.0.101.0/24", "10.0.102.0/24"]
      uat  = ["192.168.101.0/24", "192.168.102.0/24"]
 }
}
variable "vpc_private_subnets" {
  description = "Private subnets for VPC"
  type        = map(list(string))
  default     = {
      dev = ["10.0.103.0/24","10.0.104.0/24"]
      uat  = ["192.168.103.0/24","192.168.104.0/24"]
  }
}
variable "vpc_rds_subnets" {
  type = map(list(string))
  description = "(optional) describe your variable"
  default = {
    dev = ["10.0.105.0/24","10.0.106.0/24"]
    uat = ["192.168.105.0/24","192.168.106.0/24"]
  }
}
variable "enable_nat_gateway" {
  type = map
  description = "Should be true if you want to enable NAT Gateways for your private networks"
  default = {
    dev =   false
    uat  =  false
  }
}