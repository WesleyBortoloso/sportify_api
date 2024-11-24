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
        activities = current_user&.bookings.order(created_at: :desc) # Exemplo: atividades relacionadas às reservas
        BookingSerializer.new(activities)
      end
    end
  end
end
