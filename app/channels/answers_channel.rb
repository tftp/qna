class AnswersChannel < ApplicationCable::Channel

  def subscribed
    stream_from "answers#{params[:id]}"
  end

end
