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

  describe 'daily questions' do
    let!(:question_now) { create(:question) }
    let!(:question_old) { create(:question, :old) }

    it 'count all questions is correct' do
      expect(Question.count).to eq 2
    end

    it 'count daily questions is correct' do
      expect(Question.daily.count).to eq 1
    end
  end
end
