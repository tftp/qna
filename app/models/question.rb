class Question < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  scope :daily, -> { where(created_at: 1.day.ago..Time.current) }

  validates :title, :body, presence: true

end
