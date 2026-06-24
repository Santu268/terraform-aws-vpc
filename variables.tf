variable "project" {
  type        = string
  }

 variable "env" {
  type        = string
  } 

variable "vpc_tags"{
    type = map
    default = {}
}

variable "IGW_tags"{
    type = map
    default = {}
}


variable "vpc_cidr"{
  type = string
  default = "10.0.0.0/16"
}

variable "pubsub_cidr"{
  type = list
  default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "pubsub_tags"{
  type = map
  default = {}
}

variable "privatesub_tags"{
  type = map
  default = {}
}

variable "datasub_tags"{
  type = map
  default = {}
}

variable "privatesub_cidr"{
  type = list
  default = ["10.0.11.0/24","10.0.12.0/24"]
}

variable "datasub_cidr"{
  type = list
  default = ["10.0.21.0/24","10.0.22.0/24"]
}

variable "public_routetble_tags" {
  type = map
  default = {}
}

variable "private_routetble_tags" {
  type = map
  default = {}
}

variable "database_routetble_tags" {
  type = map
  default = {}
}

variable "eip_tags" {
  type = map
  default = {}
}

variable "is_peering_required" {
  type = bool
  default = false
}

variable "vpc_peering_tags" {
  type = map
  default = {}
}