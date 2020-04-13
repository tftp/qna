class NotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::Notification.new.preparing_notification(answer)
  end
end
