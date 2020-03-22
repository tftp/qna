class AuthorizationsMailer < ApplicationMailer
  def confirmation(authorization)
    @authorization = authorization

    mail to: @authorization.user.email, subject: 'Please confirm your email'
  end
end
