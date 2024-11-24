class Base < Grape::API
  helpers do
    def current_user
      @current_user ||= warden.authenticate(scope: :user)
    end

    def authenticate!
      error!('Unauthorized', 401) unless current_user
    end

    def authorize_admin!
      error!('Forbidden', 403) unless current_user&.admin?
    end

    def warden
      env['warden']
    end
  end

  rescue_from :all do |e|
    case e
    when ActiveRecord::RecordInvalid
      error_response(
        message: e.record.errors.full_messages.to_sentence,
        status: 422
      )
    when Grape::Exceptions::ValidationErrors
      error_response(
        message: e.full_messages.to_sentence,
        status: 400
      )
    else
      error_response(
        message: "An unexpected error occurred: #{e.message}",
        status: 500
      )
    end
  end

  format :json

  mount V1::Base
end
