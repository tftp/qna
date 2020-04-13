require 'rails_helper'

RSpec.describe Services::Notification do
  let(:user_subscribed) { create(:user) }
  let(:user_other) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question, user: user_other) }

  before { user_subscribed.subscriptions << question }

  it 'sends notifications for subscribed user' do
    expect(NotificationMailer).to receive(:send_notification).with(user_subscribed, answer).and_call_original
    subject.preparing_notification(answer)
  end
end
