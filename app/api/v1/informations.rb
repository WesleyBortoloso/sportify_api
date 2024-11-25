module V1
  class Informations < Grape::API
    before { authenticate! }

    resource :informations do
      # GET /informations/me
      desc 'Return current logged-in user information'
      get :me do
        UserSerializer.new(current_user)
      end

      # GET /informations/me/activity
      desc 'Return the activity history of the logged-in user'
      get 'me/activity' do
        created_bookings = current_user.bookings

        player_bookings = Booking.joins(:players).where(players: { user_id: current_user.id })

        all_bookings = (created_bookings + player_bookings).uniq.sort_by(&:created_at).reverse

        BookingSerializer.new(all_bookings)
      end
    end
  end
end
