class Answer < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user
  has_many_attached :files

  default_scope {order(best: :desc)}
  scope :sort_update_answer, -> { order(updated_at: :desc) }

  validates :body, presence: true
  validates_uniqueness_of :best, scope: :question_id, if: :best?, on: :update

  after_create :send_notification

  def set_as_best!
    return if best?
    self.transaction do
      question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end

  private

  def send_notification
    NotificationJob.perform_later(self)
  end
end
