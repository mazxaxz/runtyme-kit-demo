variable "project_name" {
  type        = string
  description = "Your Auth0's project name"

  validation {
    condition     =  var.project_name != ""
    error_message = "Auth0's project name cannot be empty"
  }
}

variable "disable_signup" {
  type        = bool
  description = "Flag indicating whether to disable sign ups to your Auth0 app"
  default     = false
}

variable "otp_enabled" {
  type        = bool
  description = "Whether to enable Auth0 Passworldless feature"
  default     = false
}

variable "otp_email_subject" {
  type        = string
  description = "Auth0's OTP Email subject, i.e. 'Here is your signin code!'"
  default     = ""

  validation {
    condition     =  (var.otp_enabled && var.otp_email_subject != "") || (!var.otp_enabled && var.otp_email_subject == "")
    error_message = "OTP Email Subject cannot be empty if Auth0 Passwordless is enabled"
  }
}

variable "otp_email_template_filepath" {
  type        = string
  description = "Path to your email template for Auth0's OTP code email"
  default     = ""

  validation {
    condition     =  (var.otp_enabled && var.otp_email_template_filepath != "") || (!var.otp_enabled && var.otp_email_template_filepath == "")
    error_message = "OTP Email Template filepath cannot be empty if Auth0 Passwordless is enabled"
  }
}

variable "otp_expire_in" {
  type        = number
  description = "Number of seconds after Auth0's OTP code expires"
  default     = 3600

  validation {
    condition     =  (var.otp_enabled && var.otp_expire_in > 60) || (!var.otp_enabled && var.otp_expire_in == 0)
    error_message = "Expiration duration cannot be less than 1 second"
  }
}

variable "otp_length" {
  type        = number
  description = "Number of characters of Auth0 OTP code"
  default     = 6

  validation {
    condition     =  (var.otp_enabled && 4 <= var.otp_length && var.otp_length <= 40) || (!var.otp_enabled && var.otp_length == 0)
    error_message = "OTP length must be between 4 and 40 characters long"
  }
}

variable "password_enabled" {
  type        = bool
  description = "Whether to enable Auth0's traditional username and password sign in feature"
  default     = false
}

variable "password_policy" {
  type        = string
  description = "Auth0's password policy configuration, available values: 'none', 'low', 'fair', 'good', 'excellent'"
  default     = "good"

  validation {
    condition     =  (var.password_enabled && can(regex("^(none|low|fair|good|excellent)$", var.password_policy))) || (!var.password_enabled && var.password_policy == "")
    error_message = "Password policy must be one of those values: 'none', 'low', 'fair', 'good', 'excellent'"
  }
}

variable "password_min_length" {
  type        = number
  description = "Auth0's minimum length of password policy'"
  default     = 8

  validation {
    condition     =  (var.password_enabled && var.password_min_length > 0 && var.password_min_length <= 128) || (!var.password_enabled && var.password_min_length == 0 && var.password_min_length == 0)
    error_message = "Password length must be between 1 and 128 characters long"
  }
}

variable "custom_smtp" {
  type        = bool
  description = "Flag indicating whether to use custom SMTP server with provided credentials or stick to default Auth0 SMTP only recommended for testing purposes"
  default     = false
}

variable "smtp_from_address" {
  type        = string
  description = "Your email address that will be used to send auth emails"

  validation {
    condition     =  (var.custom_smtp && var.smtp_from_address != "") || (!var.custom_smtp && var.smtp_from_address == "") 
    error_message = "Your auth email address cannot be empty if custom_smtp is enabled"
  }
}

variable "smtp_host" {
  type        = string
  description = "SMTP's hostname"

  validation {
    condition     =  (var.custom_smtp && var.smtp_host != "") || (!var.custom_smtp && var.smtp_host == "") 
    error_message = "SMTP host cannot be empty if custom_smtp is enabled"
  }
}

variable "smtp_port" {
  type        = number
  description = "SMTP's port number"

  validation {
    condition     =  (var.custom_smtp && var.smtp_port != 0) || (!var.custom_smtp && var.smtp_port == 0) 
    error_message = "SMTP host cannot be empty if custom_smtp is enabled"
  }
}

variable "smtp_username" {
  type        = string
  description = "SMTP's username"

  validation {
    condition     =  (var.custom_smtp && var.smtp_username != "") || (!var.custom_smtp && var.smtp_username == "") 
    error_message = "SMTP username cannot be empty if custom_smtp is enabled"
  }
}

variable "smtp_password" {
  type        = string
  description = "SMTP's password"
  sensitive   = true

  validation {
    condition     =  (var.custom_smtp && var.smtp_password != "") || (!var.custom_smtp && var.smtp_password == "") 
    error_message = "SMTP password cannot be empty if custom_smtp is enabled"
  }
}

variable "email_templates" {
  type = list(object({
    subject       = string
    relative_path = string
    template_key  = string
  }))
  description = "List email templates configuration, template_key is a key from Auth0's available email templates"
  default     = []
}

variable "allowed_origins" {
  type        = list(string)
  description = "List of allowed origins when making redirects to Auth0, used for CORS as well"
  default     = []
}

variable "site_url" {
  type        = string
  description = "Site URL which will be used as base url of actions in email buttons"

  validation {
    condition     =  var.site_url != ""
    error_message = "Site URL cannot be empty"
  }
}

variable "callback_urls" {
  type        = list(string)
  description = "Set of URLs where user will be redirected to after signing in"

  validation {
    condition     =  length(var.callback_urls) > 0
    error_message = "At least one Callback URL has to be specified"
  }
}

variable "logout_urls" {
  type        = list(string)
  description = "Set of URLs where user will be redirected to after signing out"

  validation {
    condition     =  length(var.logout_urls) > 0
    error_message = "At least one Logout URL has to be specified"
  }
}
