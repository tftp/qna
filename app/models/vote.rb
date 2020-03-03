class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, presence: true
  validates_inclusion_of :value, in: -1..1

  validates :user_id, uniqueness: { scope: [:votable_type, :votable_id] }

end
