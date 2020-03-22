class Authorization < ApplicationRecord
  belongs_to :user

  validates :uid, :confirmation_token, :provider, presence: true

end
