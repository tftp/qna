class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?

  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exeption|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exeption.message }
      format.js { render nothing: true, status: :not_found }
    end
  end

  private

  def gon_user
    gon.user_id = current_user&.id
  end
end
