# Вариант с API
ActionMailer::Base.smtp_settings = {
  user_name: 'apikey',
  password: Rails.application.credentials[Rails.env.to_sym][:sendgrid][:app_secret],
  domain: 'http://134.209.204.61', # <-здесь адрес вашего сервера
  address: 'smtp.sendgrid.net',
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}
