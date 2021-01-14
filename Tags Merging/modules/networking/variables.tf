variable "location" {
  type = string
}
variable tags {
  type = map
}
variable "vnet_address_space" {
  type    = string
  default = "172.16.0.0/22"
}
variable "gateway_subnet" {
  type    = string
  default = "172.16.0.0/26"
}
