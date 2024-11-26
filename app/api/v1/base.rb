module V1
  class Base < Grape::API
    version 'v1', using: :path
    format :json

    mount V1::Auth
    mount V1::Resources
    mount V1::Users
    mount V1::Courts
    mount V1::Bookings
    mount V1::Players
    mount V1::Informations
    mount V1::Admin::Courts
    mount V1::Public::Bookings
  end
end
