require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  describe 'validations uniqueness' do
    let(:user) {create(:user)}
    let(:question) { create(:question) }
    subject { create(:subscription, question: question, user: user) }

    it { should validate_presence_of :user_id }
    it { should validate_presence_of :question_id }
    it { should validate_uniqueness_of(:user_id).scoped_to([:question_id]) }
  end
end
