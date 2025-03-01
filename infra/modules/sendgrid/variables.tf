variable "domain" {
  type        = string
  description = "Domain name to be used as sender email"
  nullable    = true
}

variable "templates" {
  type = map(object({
    name          = string
    subject       = string
    relative_path = string
  }))
  description = "Map of dynamic email templates that will be put into SendGrid instance"
  default     = {}
}