class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def update_alone
    return if best
    Answer.where(question: question).update_all(best: false)
    self.update(best: true)
  end

end
