class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?

  private

  def gon_user
    gon.user_id = current_user.id if current_user
    gon.user_signed_in = current_user ? true : false
  end
end
