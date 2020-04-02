class Api::V1::AnswersController <  Api::V1::BaseController
  before_action :find_question, only: [:index, :create]
  before_action :find_answer, only: [:show, :update, :destroy]

  authorize_resource

  def index
    @answers = Answer.where(question: @question)
    render json: @answers, each_serializer: AnswersSerializer
  end

  def show
    render json: @answer
  end

  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      head  422
    end
  end

  def destroy
    @answer.destroy
  end

  def create
    @answer = current_resource_owner.answers.build(answer_params)
    @answer.question = @question
    if @answer.save
      render json: @answer
    else
      head  422
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, links_attributes: [:id, :name, :url, :_destroy])
  end
end
