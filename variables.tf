variable "rg_name" {
  type = string
  default = "initdb-rg"
}

variable "st_ac_name" {
  type    = string
  default = "tfstate1048584444"
}

variable "container_name" {
  type    = string
  default = "tfstate"
}

variable "key" {
  type    = string
  default = "terraform.tfstate"
}

variable "DB_ADMIN_PASSWORD" {
  type    = string
}
