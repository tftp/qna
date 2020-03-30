class UserSerializer < ActiveModel::Serializer
  attributes :id, :admin, :email, :created_at, :updated_at
end
