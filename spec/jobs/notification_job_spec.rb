require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  let(:service) { double('Service::Notification') }

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question, user: user) }

  before do
    allow(Services::Notification).to receive(:new).and_return(service)
  end

  it 'calls Services::Notification#send_mail' do
    expect(service).to receive(:send_mail).with(answer)
    NotificationJob.perform_now(answer)
  end
end
