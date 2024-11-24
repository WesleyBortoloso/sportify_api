
  module V1
    class Resources < Grape::API
      before do
        authenticate!
      end

      resource :protected do
        desc 'Access protected resource'
        get do
          { message: 'You have access to this protected resource' }
        end
      end

      helpers do
        def authenticate!
          token = headers['Authorization']&.split(' ')&.last
          payload = JWT.decode(token, Rails.application.credentials.devise[:jwt_secret_key]).first
          @current_user = User.find_by(jti: payload['jti'])

          error!('Unauthorized', 401) unless @current_user
        rescue JWT::DecodeError
          error!('Invalid token', 401)
        end
      end
    end
  end

