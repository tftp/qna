class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    trying_connect_to_provider('Github')
  end

  def facebook
    trying_connect_to_provider('Facebook')
  end

  private

  def trying_connect_to_provider(kind)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
