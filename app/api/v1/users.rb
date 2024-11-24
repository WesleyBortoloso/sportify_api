module V1
  class Users < Grape::API
    resource :users do
      desc 'Create a new user'
      params do
        requires :email, type: String, desc: 'User email'
        requires :password, type: String, desc: 'User password'
        requires :password_confirmation, type: String, desc: 'Password confirmation'
      end
      post do
        user = User::Create.call(declared(params))
        UserSerializer.new(user)
      end
    end
  end
end
