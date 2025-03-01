resource "auth0_connection" "passwordless_email" {
  count = var.otp_enabled ? 1 : 0

  strategy     = "email"
  name         = "email"
  display_name = "Passwordless Email Login"

  options {
    name                   = "email"
    from                   = var.custom_smtp ? var.smtp_from_address : ""
    subject                = var.otp_email_subject
    template               = sensitive(file(var.otp_email_template_filepath))
    syntax                 = "liquid"
    disable_signup         = var.disable_signup
    brute_force_protection = true
    non_persistent_attrs   = []
    auth_params = {
      scope         = "openid email profile offline_access"
      response_type = "code"
    }

    totp {
      time_step = var.otp_expire_in
      length    = var.otp_length
    }
  }
}

resource "auth0_connection" "email_password" {
  count = var.password_enabled ? 1 : 0

  name                 = "Email-Password-Store-RT"
  is_domain_connection = true
  strategy             = "auth0"

  options {
    password_policy                = var.password_policy
    brute_force_protection         = true
    strategy_version               = 2
    enabled_database_customization = false
    import_mode                    = false
    requires_username              = false
    disable_signup                 = var.disable_signup

    password_complexity_options {
      min_length = var.password_min_length
    }

    password_history {
      enable = false
    }

    password_no_personal_info {
      enable = false
    }

    password_dictionary {
      enable = false
    }

    mfa {
      active = false
    }
  }
}