module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def count_votes
    Vote.find_votables(votable: self).pluck(:value).sum
  end

end
