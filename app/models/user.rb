class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github, :facebook]

 has_many :questions, dependent: :destroy
 has_many :answers, dependent: :destroy
 has_many :votes, dependent: :destroy
 has_many :comments, dependent: :destroy
 has_many :authorizations, dependent: :destroy

 has_many  :subscriptions, dependent: :destroy
 has_many  :subscribe_questions, through: :subscriptions, source: :question, class_name: "Question"

 validates :email, format: { with: /\A\w+@\w+\.[a-z]{2,3}\z/}

 def is_author?(obj)
   id == obj.user_id
 end

 def self.find_for_oauth(auth)
   Services::FindForOauth.new(auth).call
 end

end
