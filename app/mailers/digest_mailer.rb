class DigestMailer < ApplicationMailer
  def digest(user)
    @questions_daily = Question.daily

    mail to: user.email
  end
end
