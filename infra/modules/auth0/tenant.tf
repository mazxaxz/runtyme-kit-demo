resource "auth0_tenant" "self" {
  friendly_name         = var.project_name
  idle_session_lifetime = 72
  session_lifetime      = 168
  enabled_locales       = ["en"]

  allow_organization_name_in_authentication_api = false
  customize_mfa_in_postlogin_action             = false
  disable_acr_values_supported                  = true
  pushed_authorization_requests_supported       = false


  flags {
    disable_clickjack_protection_headers   = true
    enable_public_signup_user_exists_error = false
    use_scope_descriptions_for_consent     = true
    disable_management_api_sms_obfuscation = false
    disable_fields_map_fix                 = false
  }

  session_cookie {
    mode = "non-persistent"
  }

  sessions {
    oidc_logout_prompt_enabled = false
  }
}

data "auth0_tenant" "self" {}
