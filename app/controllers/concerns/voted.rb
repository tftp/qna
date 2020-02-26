module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote]
    before_action :set_vote, only: [:vote]
  end

  def vote
    option = params[:option]
    send(option.to_sym)
    @vote.save
  end

  private

  def positive
    # повторное нажатие обнуляет голос
    @vote.value = @vote.value.zero? ? 1 : 0
  end

  def negative
    # повторное нажатие обнуляет голос
    @vote.value = @vote.value.zero? ? -1 : 0
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def set_vote
    @vote = find_votable(@votable) ? find_votable(@votable) : @votable.votes.build(user: current_user)
  end

  def find_votable(votable)
    Vote.find_votables(votable: votable, user: current_user).first
  end
end
