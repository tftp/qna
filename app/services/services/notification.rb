class Services::Notification
  def send_mail(answer)
    @question = answer.question
    User.where(question: @question).each do |user|
      NotificationMailer.send(user, answer).deliver_later
    end
  end
end
