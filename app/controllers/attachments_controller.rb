class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @attachment.destroy if current_user.is_author?(@attachment.record)
    redirect_to (@attachment.record.class.eql? Question) ? @attachment.record : @attachment.record.question
  end

end
