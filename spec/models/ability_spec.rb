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
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:question_user) { create(:question, user: user) }
    let(:question_other) { create(:question, user: other) }
    let(:answer_user) { create(:answer, question: question_user, user: user) }
    let(:answer_other) { create(:answer, question: question_user, user: other) }
    let(:comment_user) { create(:comment, commentable: question_user, user: user) }
    let(:comment_other) { create(:comment, commentable: question_user, user: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it {should be_able_to :create, Question}
    it {should be_able_to :create, Answer}
    it {should be_able_to :create, Comment}

    it { should be_able_to :update, question_user }
    it { should_not be_able_to :update, question_other }

    it { should be_able_to :update, answer_user }
    it { should_not be_able_to :update, answer_other }

    it { should be_able_to :update, comment_user }
    it { should_not be_able_to :update, comment_other }
  end
end
