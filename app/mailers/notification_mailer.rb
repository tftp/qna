class NotificationMailer < ApplicationMailer
  def send(user, answer)
    @answer = answer

    mail to: user.email
  end
end
