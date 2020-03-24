class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  after_action :publish_question, only: [:create]

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.build
    @question = Question.with_attached_files.find(params[:id])
    gon.question_id = @question.id
    gon.question_author_id = @question.user_id
  end

  def new
    question.links.build
    question.comments.build
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

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
     'questions',
     ApplicationController.render(
       partial: 'questions/question',
       locals: { question: @question }
     )
   )
  end

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  def question_params
    params.require(:question).permit(:title, :body,
                                      files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

end
