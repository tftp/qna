class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true, touch: true

  validates :name, :url, presence: true
  validates :url, format: { with: /\A(https?:\/\/)([\da-z\.-]+)\.([a-z\.]{2,6})(\/[\w\.-]*)*\/?\z/}

  def gist?
    url.include?('gist.github.com')
  end
end
