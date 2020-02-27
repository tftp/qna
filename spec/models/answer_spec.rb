require 'rails_helper'

RSpec.describe Answer, type: :model do
  include_examples "Linkable"

  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

  describe 'an order of answer' do
    let(:answers) { create_list(:answer, 2, question: question, user: author) }
    let(:best_answer) { create(:answer, :best, question: question, user: author) }

    it 'best answer is in top' do

      expect(question.answers).to eq [ best_answer, answers[0], answers[1] ]
    end
  end

  describe 'answer can check as best' do
    let(:answers) { create_list(:answer, 2, question: question, user: author) }

    it 'set on best as true of the current and set off of the other answer' do
      answers[0].set_as_best!

      expect(answers[0].reload).to be_best
      expect(answers[1].reload).not_to be_best

      answers[1].set_as_best!

      expect(answers[1].reload).to be_best
      expect(answers[0].reload).not_to be_best
    end
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'Vote' do
    it_behaves_like "votable"
  end

end
