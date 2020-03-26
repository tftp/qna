# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_ability : user_ability
    else
      quest_ability
    end
  end

  private

  def quest_ability
    can :read, :all
  end

  def admin_ability
    can :manage, :all
  end

  def user_ability
    quest_ability

    # set_rules_for_question
    can :create, Question
    can [:update, :destroy], Question, user_id: @user.id
    can :vote, Question do |question|
       !@user.is_author?(question)
     end

    # set_rules_for_answer
    can :create, Answer
    can [:update, :destroy], Answer, user_id: @user.id
    can :best, Answer, question: { user_id: @user.id }
    can :vote, Answer do |answer|
       !@user.is_author?(answer)
     end

    # set_rules_for_comment
    can :create, Comment

    # set_rules_for_attachment
    can :manage, ActiveStorage::Attachment do |attachment|
      attachment.record.user_id == user.id
    end
  end
end
