class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  after_action :publish_answer, only: [:create]

  def new
    @answer = Answer.new
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params) if current_user.is_author?(@answer)
    @question = @answer.question
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = current_user.answers.build(answer_params)
    @answer.question = @question
    @answer.save


  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy if current_user.is_author?(@answer)
  end

  def best
    @answer = Answer.find(params[:id])
    @answer.set_as_best! if current_user.is_author?(@answer.question)
  end

  private

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
     "answers#{@question.id}",
     @answer.to_json
   )
  end

  def answer_params
    params.require(:answer).permit(:body,
                                    files: [], links_attributes: [:id, :name, :url, :_destroy])
  end
end
