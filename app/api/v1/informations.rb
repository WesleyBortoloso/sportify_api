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

      desc 'Return key statistics for the logged-in user'
      get 'me/stats' do
        user = current_user
        next_game = user.bookings
                        .where('starts_on > ?', Time.now)
                        .order(:starts_on)
                        .first
        total_time_this_month = user.bookings
                                    .where('starts_on >= ? AND ends_on <= ?',
                                            Time.now.beginning_of_month,
                                            Time.now.end_of_month)
                                    .sum("EXTRACT(EPOCH FROM (ends_on - starts_on)) / 3600").to_i
        total_reservations = user.bookings
                                 .where('starts_on >= ?', Time.now.beginning_of_month)
                                 .count
        public_games_count = Booking.where(public: true)
                                    .where('starts_on > ?', Time.now)
                                    .count
        next_public_game = Booking.where(public: true)
                                  .where('starts_on > ?', Time.now)
                                  .order(:starts_on)
                                  .first
        present({
          stats: [
            {
              id: 1,
              label: 'Próximo Jogo',
              value: next_game.present? ? next_game.starts_on.strftime('%d/%m às %Hh') : 'Nenhum jogo agendado',
              info: next_game.present? ? next_game.court.name : nil
            },
            {
              id: 2,
              label: 'Tempo em Quadra',
              value: "#{total_time_this_month}h",
              info: 'Este mês'
            },
            {
              id: 3,
              label: 'Reservas Feitas',
              value: total_reservations,
              info: 'Este mês'
            },
            {
              id: 4,
              label: 'Jogos Públicos Disponíveis',
              value: public_games_count,
              info: next_public_game.present? ? "Próximo: #{next_public_game.starts_on.strftime('%d/%m às %Hh')}" : 'Sem jogos disponíveis',
            }
          ]
        })
      end
    end
  end
end
