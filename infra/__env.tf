// Get full version at https://runtyme.co/#pricing

locals {
  #  ________________________________________
  # |  ____________________________________  |
  # | | ============ Gateway ============= | |
  # | |____________________________________| |
  # |________________________________________|
  // (required if Cloudflare and/or CORS enabled)
  domain = {
    // (required) Your project's domain value
    root = "example.com"
  }
  #  ________________________________________
  # |  ____________________________________  |
  # | | ============ Emails ============== | |
  # | |____________________________________| |
  # |________________________________________|
  sendgrid = {
    enabled = false
    // (required) This is the email address the emails will be sent from
    sender_email = "noreply@example.com"
    // (required) Name displayed in the recipient's inbox
    sender_name = "example.com"

    templates = {
      account_delete_requested : {
        name          = "account_delete_requested"
        subject       = "[your_app] We've received your Account deletion request"
        relative_path = "/_templates/emails/account_delete_requested.html"
      }
    }
  }
  #  ________________________________________
  # |  ____________________________________  |
  # | | ========== Persistence =========== | |
  # | |____________________________________| |
  # |________________________________________|
  auth0 = {
    enabled = false
    // (required) Name of your project, it'll be visible on sign-in/sign-up page
    project_name = "Runtyme Kit"
    // (optional) By setting this to 'true' you forbid users to sign-up to your platform, this might be a case when
    // you'd want to have users created from Stripe flow, or users being invited
    // default: false
    disable_signup = false

    // (optional) This is the Site URL that will be used as base URL for a Magic Link
    // default: https://localhost:3000, no wildards (*) allowed
    site_url = "https://example.com"
    // (optional) Tell Auth0 here that this URL is safe to redirect users to after they attempt log out
    after_logout_url = "https://example.com/sign-in"

    // optional
    otp = {
      // IMPORTANT: To enable Passwordless flow in Auth0's Universal Login page, `auth0.password.enabled` must be set to false
      // otherwise Username + Password flow will be used by default
      enabled = false
      // (optional) Time after Magic Link will expire and will no longer be valid
      // default: 3600 - 1h, Minimum: 60
      expire_in = 3600
      // (optional) Number of generated characters for OTP auth
      // default: 6, Minimum: 4, Maximum: 40
      code_length = 6
      // (required) Subject of an email sent when passwordless flow is triggered
      email_subject = "[your_app] Your Magic Link"
      // (required) Contents of an email sent when passwordless flow is triggered
      email_template_relative_path = "/_templates/emails/auth0/otp.html"
    }

    // optional
    password = {
      enabled = false
      // (optional) Specific Auth0 password policy, available values: 'none', 'low', 'fair', 'good', 'excellent'
      policy = "good"
      // (optional) Passwords shorter than this value will be rejected as weak. 
      // default: 8, Minimum 1, Maximum 128, recommended 8 or more.
      min_length = 8
    }

    // (optional)
    // Possible values (and the name of it in Auth0 dashboard):
    // - verify_email         (Verification Email (Link))
    // - verify_email_by_code (Verification Email (Code))
    // - reset_email          (Change Password (Link))
    // - welcome_email        (Welcome Email)
    // - blocked_account      (Blocked Account Email)
    // - stolen_credentials   (Password Breach Alert)
    // - enrollment_email     (Enroll in Multifactor Authentication)
    // - mfa_oob_code         (Verification Code for for Email MFA)
    // - user_invitation      (User Invitation)
    email_templates = {
      verify_email : {
        subject                = "[your_app] Verify your account"
        template_relative_path = "/_templates/emails/auth0/verify-email.html"
      }
      reset_email : {
        subject                = "[your_app] Reset Your Password"
        template_relative_path = "/_templates/emails/auth0/reset-password.html"
      }
      user_invitation : {
        subject                = "[your_app] You have been invited"
        template_relative_path = "/_templates/emails/auth0/invite-user.html"
      }
    }

    // (optional) Specify custom SMTP server for Auth0 emails
    // NOTE: If empty, default shared Auth0 server will be used, not recommended for production application
    smtp = {
      // (optional) If set to 'true' AND 'sendgrid.enabled=true', configured SendGrid SMTP server will be used
      // default: false
      use_sendgrid = false
    }
  }
}