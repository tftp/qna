class Api::V1::QuestionsController <  Api::V1::BaseController
  before_action :find_question, only: [:update, :destroy, :show]

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question
  end

  def create
    @question = current_resource_owner.questions.new(question_params)
    if @question.save
      render json: @question
    else
      head  422
    end
  end

  def update
    if @question.update(question_params)
      render json: @question
    else
      head  422
    end
  end

  def destroy
    @question.destroy
  end

  private
  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: [:id, :name, :url, :_destroy])
  end
end
