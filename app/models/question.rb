class Question < ApplicationRecord
  include Linkable
  include Badgeable

  has_many :answers, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  validates :title, :body, presence: true

end
