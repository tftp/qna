class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_answer, only: [ :update, :destroy, :best ]
  after_action :publish_answer, only: [:create]

  authorize_resource

  def new
    @answer = Answer.new
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = current_user.answers.build(answer_params)
    @answer.question = @question
    @answer.save
  end

  def destroy
    @answer.destroy
  end

  def best
    authorize! :best, @answer
    @answer.set_as_best!
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
     "answers-for-question-#{@question.id}",
     answer: @answer,
     links: @answer.links
   )
  end

  def answer_params
    params.require(:answer).permit(:body,
                                    files: [], links_attributes: [:id, :name, :url, :_destroy])
  end
end
