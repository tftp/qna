class AnswersChannel < ApplicationCable::Channel

  def subscribed
    stream_from "answers-for-question-#{params[:id]}"
  end
end
