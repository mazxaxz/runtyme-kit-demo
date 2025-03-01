// Get full version at https://runtyme.co/#pricing

variable "SENDGRID_API_KEY" {
  type      = string
  sensitive = true
  default   = "[null]"
}

variable "AUTH0_DOMAIN" {
  type      = string
  sensitive = true
  default   = "[null]"
}

variable "AUTH0_CLIENT_ID" {
  type      = string
  sensitive = true
  default   = "[null]"
}

variable "AUTH0_CLIENT_SECRET" {
  type      = string
  sensitive = true
  default   = "[null]"
}
