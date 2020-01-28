class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

 has_many :questions
 has_many :answers

 validates :email, format: { with: /\A\w+@\w+\.[a-z]{2,3}\z/}

 def is_author?(obj)
   answers.include?(obj) || questions.include?(obj)
 end
 
end
