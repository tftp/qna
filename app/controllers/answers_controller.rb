class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!

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

  def answer_params
    params.require(:answer).permit(:body,
                                    files: [], links_attributes: [:id, :name, :url, :_destroy])
  end
end
