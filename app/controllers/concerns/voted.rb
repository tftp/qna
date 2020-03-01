module Voted
  extend ActiveSupport::Concern

  def vote
    set_votable
    set_vote
    voting_process(params[:option])
    if !current_user.is_author?(@votable) && @vote.save
       render json: @votable.count_votes
    else
       render json:'Unprocessable Entity', status: 422
    end
  end

  private

  def voting_process(option)
    positive if option.eql? 'positive'
    negative if option.eql? 'negative'
  end

  def positive
    # повторное нажатие plus обнуляет голос
    @vote.value = @vote.value.zero? ? 1 : 0
  end

  def negative
    # повторное нажатие minus обнуляет голос
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
    Vote.find_by votable: votable, user: current_user
  end
end
