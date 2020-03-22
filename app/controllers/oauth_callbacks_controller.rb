class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def facebook
    @authorization = Services::FindForOauth.new(request.env['omniauth.auth']).call
    if request.env['omniauth.auth'].info[:email]
      continue_authentication_with_email(@authorization,'Facebook')
    else
      continue_authentication_without_email(@authorization,'Facebook')
    end
  end

  private

  def continue_authentication_with_email(authorization, kind)
    @user = authorization.user
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def continue_authentication_without_email(authorization, kind)
    if authorization&.confirmation_at?
      @user = authorization.user
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      session[:provider] = request.env['omniauth.auth'].provider
      session[:uid] = request.env['omniauth.auth'].uid
      redirect_to new_authorization_path
    end
  end
end
