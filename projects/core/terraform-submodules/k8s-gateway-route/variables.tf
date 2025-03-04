variable "kubernetes_service" {
  type = object({
    metadata = list(object({
      name      = string
      namespace = string
    }))
  })
}

variable "domain" {
  type = string
}

variable "service_port" {
  type    = number
  default = 80
}
