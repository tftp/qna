class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.build
    @question = Question.with_attached_files.find(params[:id])
  end

  def new
    question.links.build
    question.build_badge
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update
    question.update(question_params) if current_user.is_author?(question)
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
    params.require(:question).permit(:title, :body, files: [],
                                      links_attributes: [:id, :name, :url, :_destroy],
                                      badge_attributes: [:id, :name, :file, :_destroy])
  end

end
