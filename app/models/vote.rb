class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, presence: true
  validates_inclusion_of :value, in: -1..1

  #эта проверка не идет, наверное нельзя проверить множественные поля на уникальность
  #validates [:users, :votable_type, :votable_id], uniqueness: true

  scope :find_votables, -> (params){ params[:user] ? where(votable: params[:votable], user: params[:user]) : where(votable: params[:votable]) }

end
