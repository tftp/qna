class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @subscription = Subscription.create(user: current_user, question: @question)
  end

  def destroy
    @question = Question.find(params[:question_id])
    @subscription = Subscription.find(params[:id])
    authorize! :destroy, @subscription
    
    @subscription.destroy if @subscription
  end
end
