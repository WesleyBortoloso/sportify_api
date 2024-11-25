class UserSerializer
  include JSONAPI::Serializer

  set_type :user
  attributes :email, :name, :document, :role
end
