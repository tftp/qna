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
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], user_id: @user.id
  end
end
