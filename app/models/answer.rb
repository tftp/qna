class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def has_author?(user)
    self.user == user
  end
end
