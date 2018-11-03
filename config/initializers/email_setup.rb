ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true

ActionMailer::Base.smtp_settings = {
  :address              => Settings.email.address,
  :port                 => Settings.email.port,
  :domain               => Settings.email.domain,
  :user_name            => Figaro.env.gmail_username,
  :password             => Figaro.env.gmail_password,
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default :from => Settings.email.default_from
