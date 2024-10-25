variable "google_project" {
  type = object({
    project_id = string
  })
}

variable "bucket_name" {
  type = string
}

variable "bucket_location" {
  type = string
}

variable "iam_readers" {
  type    = set(string)
  default = []
}
variable "iam_writers" {
  type    = set(string)
  default = []
}
