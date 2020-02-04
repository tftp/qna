class AnswersController < ApplicationController
  before_action :authenticate_user!

  def new
    @answer = Answer.new
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = @answer.question
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = current_user.answers.build(answer_params)
    @question.answers << @answer
    @answer.save
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy if current_user.is_author?(@answer)
  end

  def best
    @answer = Answer.find(params[:id])
    @answer.update_alone if current_user.is_author?(@answer.question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
