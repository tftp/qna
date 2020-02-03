class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @question = Question.find(params[:id])
  end

  def new

  end

  def edit
  end

  def create
    @user = current_user
    @question = @user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update
    question.update(question_params)
  end

  def destroy
    question.destroy if current_user.is_author?(question)
    redirect_to questions_path
  end

  helper_method :question

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

end
