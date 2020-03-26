class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    authorize! :destroy, @attachment
    @attachment.destroy 
    redirect_to (@attachment.record.class.eql? Question) ? @attachment.record : @attachment.record.question
  end
end
