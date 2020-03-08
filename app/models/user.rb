class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

 has_many :questions, dependent: :destroy
 has_many :answers, dependent: :destroy
 has_many :votes, dependent: :destroy
 has_many :comments, dependent: :destroy

 validates :email, format: { with: /\A\w+@\w+\.[a-z]{2,3}\z/}

 def is_author?(obj)
   id == obj.user_id
 end

end
