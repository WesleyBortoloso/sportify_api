
  module V1
    class Auth < Grape::API
      resource :auth do
        desc 'User login'
        params do
          requires :email, type: String, desc: 'Email'
          requires :password, type: String, desc: 'Password'
        end
        post :sign_in do
          user = User.find_by(email: params[:email])
          if user&.valid_password?(params[:password])
            token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
            { token: token, user: user }
          else
            error!('Invalid email or password', 401)
          end
        end

        desc 'User logout'
        delete :sign_out do
          auth_token = headers['Authorization']&.split(' ')&.last
          if auth_token
            jti = JWT.decode(auth_token, Rails.application.credentials.devise[:jwt_secret_key]).first['jti']
            JwtDenylist.create!(jti: jti, exp: Time.at(JWT.decode(auth_token, nil, false).first['exp']))
            { message: 'Logged out successfully' }
          else
            error!('Authorization token missing', 401)
          end
        end
      end
    end
  end
