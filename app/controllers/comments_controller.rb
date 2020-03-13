class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: [:create]

  def create
    @comment = commentable.comments.build(comment_params.merge(user: current_user))
    @comment.save
  end

  private

  def commentable
    if params[:question_id]
      Question.find(params[:question_id])
    else
      Answer.find(params[:answer_id])
    end
  end

  def question_id
    commentable.respond_to?(:question_id) ? commentable.question.id : commentable.id
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast(
      "comments-for-question-#{question_id}",
      comment: @comment
    )
  end

end
