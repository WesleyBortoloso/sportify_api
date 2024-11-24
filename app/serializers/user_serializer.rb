class UserSerializer
  include JSONAPI::Serializer

  set_type :user
  attributes :email, :created_at
end
