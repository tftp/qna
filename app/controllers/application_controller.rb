class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exeption|
    redirect_to root_url, alert: exeption.message
  end

  private

  def gon_user
    gon.user_id = current_user&.id
  end
end
