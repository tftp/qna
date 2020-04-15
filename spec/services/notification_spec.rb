require 'rails_helper'

RSpec.describe Services::Notification do
  let(:user_subscribed) { create(:user) }
  let(:user_other) { create(:user) }
  let(:question) { create(:question, user: user_subscribed) }
  let(:answer) { create(:answer, question: question, user: user_other) }

  it 'sends notifications for subscribed user' do
    expect(NotificationMailer).to receive(:send_notification).with(user_subscribed, answer).and_call_original
    subject.preparing_notification(answer)
  end

  it 'does not sends notifications for unsubscribed user' do
    expect(NotificationMailer).to_not receive(:send_notification).with(user_other, answer)
    subject.preparing_notification(answer)
  end
end
