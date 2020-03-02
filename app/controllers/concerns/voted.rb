module Voted
  extend ActiveSupport::Concern

  def vote
    @votable = model_klass.find(params[:id])
    @vote = find_votable(@votable) ? find_votable(@votable) : @votable.votes.build(user: current_user)
    counts_voice(params[:option])
    if !current_user.is_author?(@votable) && @vote.save
       render json: @votable.rating
    else
       render json:'Unprocessable Entity', status: 422
    end
  end

  private

  def counts_voice(option)
    positive if option == 'positive'
    negative if option == 'negative'
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

  def find_votable(votable)
    Vote.find_by votable: votable, user: current_user
  end
end
