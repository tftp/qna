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
        expect(author).to be_is_author(self_question)
    end

    it 'self answer' do
      expect(author).to be_is_author(self_answer)
    end
  end

  describe 'is not author' do
    it 'somebody question' do
      expect(author).not_to be_is_author(somebody_question)
    end

    it 'somebody answer' do
      #можно я это оставлю в качестве примера преобразования?
      #expect(author.is_author?(somebody_answer)).to eq false
      expect(author).not_to be_is_author(somebody_answer)
    end
  end

  describe 'answer can check as best' do
    let(:answers) { create_list(:answer, 2, question: self_question, user: author) }

    it 'set on best as true of the current and set off of the other answer' do
      answers[0].set_as_best!

      expect(answers[0]).to be_best
      expect(answer[1]).not_to be_best

      answers[1].set_as_best!

      expect(answers[1]).to be_best
      expect(answer[0]).not_to be_best
    end
  end
end
