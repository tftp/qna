class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github, :facebook, :twitter]

 has_many :questions, dependent: :destroy
 has_many :answers, dependent: :destroy
 has_many :votes, dependent: :destroy
 has_many :comments, dependent: :destroy
 has_many :authorizations

 validates :email, format: { with: /\A\w+@\w+\.[a-z]{2,3}\z/}

 def is_author?(obj)
   id == obj.user_id
 end

 def self.find_for_oauth(auth)
   authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
   return authorization.user if authorization

   email = auth.info[:email]
   user = User.where(email: email).first
   if user
     user.authorizations.create(provider: auth.provider, uid: auth.uid)
   else
     password = Devise.friendly_token[0, 20]
     user = User.create!(email: email, password: password, password_confirmation: password)
     user.authorizations.create(provider: auth.provider, uid: auth.uid)
   end
   user
 end

end
