class AnswersController < ApplicationController
  before_action :authenticate_user!

  def new
    @answer = Answer.new
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    current_user.answers.push @answer
    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created'
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy if current_user.is_author?(@answer)
    redirect_to question_path(@answer.question_id)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end


end
