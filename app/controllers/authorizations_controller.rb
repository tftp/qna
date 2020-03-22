class AuthorizationsController < ApplicationController

  def new
  end

  def create
    email = params[:email]
    password = Devise.friendly_token
    @user = User.find_by(email: email)
    @user ||= User.new(email: email, password: password, password_confirmation: password)
    unless @user.save
      render :new
    else
      @authorization = @user.authorizations.create(provider: session[:provider],
                                                   uid: session[:uid],
                                                   confirmation_token: Devise.friendly_token,
                                                   confirmed_at: nil) if @user
      if @authorization&.persisted?
        AuthorizationsMailer.confirmation(@authorization).deliver_now
        message = "Confirm send to email #{email}"
      else
        message = 'Confirm wrong'
      end
      redirect_to root_path, notice: message
    end
  end

  def confirmable
    @authorization = Authorizations.find_by(confirmation_token: params[:confirmation_token])
    if @authorization && @authorization.confirmation_at.nil?
      authorization.update(confirmation_at: Time.current)
      redirect_to sign_in_path, notice: 'Confirmation is success'
    else
      redirect_to sign_in_path, notice: 'Confirmation is wrong'
    end
  end
end
