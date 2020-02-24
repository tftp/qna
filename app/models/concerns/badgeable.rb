module Badgeable
  extend ActiveSupport::Concern

  included do
    has_one :badge, dependent: :destroy, as: :badgeable
    accepts_nested_attributes_for :badge, reject_if: :all_blank, allow_destroy: true
  end

end
