class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  default_scope {order(best: :desc)}

  validates :body, presence: true
  validate :best_is_only_one_true, on: :update

  def set_as_best!
    return if best
    self.transaction do
      question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end

  private

  def best_is_only_one_true
    errors.add(:best)  if question.answers.where(best: true).count > 1
  end

end
