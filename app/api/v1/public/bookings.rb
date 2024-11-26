module V1
  module Public
    class Bookings < Grape::API
      resource :public do
        resource :bookings do
          # GET /bookings/:share_token
          desc 'Return bookings related from a share token'
          params do
            requires :share_token, type: String, desc: 'Booking share token'
          end

          get ':share_token' do
            booking = Booking.find_by(share_token: params[:share_token])
            BookingSerializer.new(booking)
          end
        end
      end
    end
  end
end

