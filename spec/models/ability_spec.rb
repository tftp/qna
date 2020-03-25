require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for quest' do
    let(:user) { nil }

    it {should be_able_to :read, Question}
    it {should be_able_to :read, Answer}
    it {should be_able_to :read, Comment}

    it {should_not be_able_to :manage, :all}
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:other) { create(:user) }
    let(:user) { create(:user) }
    let(:question_user) { create(:question, user: user) }
    let(:question_other) { create(:question, user: other) }
    let(:answer_user) { create(:answer, question: question_user, user: user) }
    let(:answer_other) { create(:answer, question: question_other, user: other) }
    let(:comment_user) { create(:comment, commentable: question_user, user: user) }
    let(:comment_other) { create(:comment, commentable: question_user, user: other) }
    let(:file) { create_file_blob('rails_helper.rb') }
    let(:attachment_user) do
      question_user.files.attach(file)
      question_user.files.last
    end
    let(:attachment_other) do
      question_other.files.attach(file)
      question_other.files.last
    end


    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'for Question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :update, question_user }
      it { should_not be_able_to :update, question_other }
      it { should be_able_to :destroy, question_user }
      it { should_not be_able_to :destroy, question_other }
      it { should be_able_to :vote, question_other }
      it { should_not be_able_to :vote, question_user }
    end

    context 'for Answer' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :update, answer_user }
      it { should_not be_able_to :update, answer_other }
      it { should be_able_to :destroy, answer_user }
      it { should_not be_able_to :destroy, answer_other }
      it { should be_able_to :vote, answer_other }
      it { should_not be_able_to :vote, answer_user }
      it { should be_able_to :best, answer_user }
      it { should_not be_able_to :best, answer_other }
    end

    context 'for Comment' do
      it { should be_able_to :create, Comment }
    end

    context 'for Attachment' do
      it { should be_able_to :destroy, attachment_user }
      it { should_not be_able_to :destroy, attachment_other }
    end

  end
end
