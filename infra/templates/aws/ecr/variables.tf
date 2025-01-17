variable "repositories" {
  type        = any
  description = "Repositories list"
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "days_to_remove_untagged_images" {
  type = number
  description = "days to remove untagged images"
  default = 3
}

variable "pr_image_count" {
  type = number
  description = "days to remove pull-request images"
  default = 7
}

variable "max_image_count" {
  type = number
  description = "days to remove untagged images"
  default = 50
}
