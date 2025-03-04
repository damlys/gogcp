variable "old_domain" {
  type = string
}

variable "new_domain" {
  type = string
}

variable "status_code" {
  type    = number
  default = 301
}
