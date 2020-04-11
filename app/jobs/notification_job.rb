class NotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::Notification.new.send_mail(answer)
  end
end
