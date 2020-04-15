class Services::Notification
  def preparing_notification(answer)
    @question = answer.question
    User.find_each(batch_size: 500) do |user|
      if user.subscribe_questions.exists?(@question.id)
        NotificationMailer.send_notification(user, answer).try(:deliver_later)
      end
    end
  end
end
