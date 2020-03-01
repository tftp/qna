require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:votable) }
  it { should belong_to(:user) }

  it { should validate_presence_of :value }
  it { should validate_inclusion_of(:value).in_range(-1..1) }

  describe 'validations uniqueness' do
    let(:user) {create(:user)}
    let(:question) { create(:question, user: user) }
    subject { create(:vote, votable: question, user: user) }
    
    it { should validate_uniqueness_of(:user_id).scoped_to([:votable_type, :votable_id]) }
  end
end
