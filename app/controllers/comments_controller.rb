class CommentsController < ApplicationController
  before_action :authenticate_user!

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

  def comment_params
    params.require(:comment).permit(:body)
  end

end
