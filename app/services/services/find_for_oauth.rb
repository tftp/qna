class Services::FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization if authorization

    email = auth.info[:email] if auth.info
    user = User.where(email: email).first if email
    return user.authorizations.create(provider: auth.provider,
                                      uid: auth.uid,
                                      confirmation_token: Devise.friendly_token,
                                      confirmed_at: Time.current) if user

    password = Devise.friendly_token[0, 20]
    if email
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.authorizations.create(provider: auth.provider,
                                 uid: auth.uid,
                                 confirmation_token: Devise.friendly_token,
                                 confirmed_at: Time.current)
    end
  end
end
