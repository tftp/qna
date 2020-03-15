require 'rails_helper'

RSpec.describe Question, type: :model do
  include_examples "Linkable"
  include_examples "Commentable"

  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'Vote' do
    let(:votable) { create(:question, user: user) }

    it_behaves_like "votable"
  end
end
