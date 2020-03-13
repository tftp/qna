class CommentsChannel < ApplicationCable::Channel

  def subscribed
    stream_from "comments-for-question-#{params[:id]}"
  end
end
