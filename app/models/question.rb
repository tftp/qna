class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :user

  has_many_attached :files

  validates :title, :body, presence: true

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
end
