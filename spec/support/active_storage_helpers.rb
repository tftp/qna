module ActiveStorageHelpers
  def create_file_blob(file)
    ActiveStorage::Blob.create_after_upload! io: File.open("#{Rails.root}/spec/#{file}"), filename: "#{file}", content_type: 'text/plain'
  end
end
