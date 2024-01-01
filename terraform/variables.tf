variable "app_name" {
  type        = string
  description = "Application name"
  default     = "cassandra"
}

variable "image" {
  type        = string
  description = "Image name alongside with its version"
  default     = "cassandra:3.11"
}