require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  let(:author) { create(:user) }
  let(:somebody) { create(:user) }
  let(:self_question) { create(:question, user: author) }
  let(:somebody_question) { create(:question, user: somebody) }
  let(:self_answer) { create(:answer, question: self_question, user: author) }
  let(:somebody_answer) { create(:answer, question: somebody_question, user: somebody) }

  describe 'is author ' do
    it 'self question' do
        expect(author.is_author?(self_question)).to eq true
    end

    it 'self answer' do
      expect(author.is_author?(self_answer)).to eq true
    end
  end
  describe 'is not author' do
    it 'somebody question' do
      expect(author.is_author?(somebody_question)).to eq false
    end

    it 'somebody answer' do
      expect(author.is_author?(somebody_answer)).to eq false
    end

  end
end
