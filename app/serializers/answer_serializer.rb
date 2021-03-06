class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :created_at, :updated_at, :user_id, :files_url

  has_many :comments
  has_many :links

  def files_url
    urls = []
    object.files.each do |file|
      urls << { name: file.filename.to_s,
                url: rails_blob_path(file, only_path: true) }
    end
    return urls
  end
end
