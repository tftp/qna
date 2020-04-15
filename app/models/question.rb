class Question < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many  :subscriptions, dependent: :destroy
  has_many  :subscribe_users, through: :subscriptions, source: :user, class_name: "User"

  has_many_attached :files

  scope :daily, -> { where(created_at: 1.day.ago..Time.current) }

  validates :title, :body, presence: true

  after_create :subscribe_user

  private

  def subscribe_user
    self.user.subscribe_questions << self
  end
end
