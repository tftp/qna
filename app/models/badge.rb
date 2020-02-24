class Badge < ApplicationRecord
  belongs_to :badgeable, polymorphic: true

  has_one_attached :file

  validates :name, presence: true
  validates :file, presence: true

end
