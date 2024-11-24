module V1
  class Bookings < Grape::API
    before { authenticate! }

    resource :bookings do
      # POST /bookings
      desc 'Create a new booking for a court'
      params do
        requires :court_id, type: Integer, desc: 'The related court id'
        requires :starts_on, type: DateTime, desc: 'The booking starts on date and time'
        requires :public, type: Boolean, desc: 'Booking public state'
      end

      post do
        booking = Booking::Create.call(declared(params), current_user: current_user)
        BookingSerializer.new(booking)
      end

      # GET /bookings
      desc 'Return a list of bookings'

      params do
        optional :filter, type: Hash, desc: 'Filtering parameters'
      end

      get do
        bookings = Booking.ransack(params[:filter]).result
        BookingSerializer.new(bookings)
      end

      # PUT /bookings/:id
      desc 'Update a related booking'
      params do
        requires :id, type: Integer, desc: 'Booking id'
        optional :status, type: String, values: %w[agendado cancelado concluido], desc: 'Bokking status'
        optional :public, type: Boolean, desc: 'Booking public state'
      end

      put ':id' do
        booking = Booking::Update.call(declared(params))
        BookingSerializer.new(booking)
      end

      # GET /bookings/:id
      desc 'Return bookings details'
      params do
        requires :id, type: Integer, desc: 'Booking ID'
      end

      get ':id' do
        booking = Booking.find(params[:id])
        BookingSerializer.new(booking)
      end

      desc 'Lista os horários disponíveis para uma quadra específica'
      params do
        requires :id, type: Integer, desc: 'ID da quadra'
        optional :date, type: Date, desc: 'Data para verificar os horários disponíveis', default: Date.today
      end

      get ':id/available_times' do
        court = Court.find(params[:id])

        opening_time = Time.zone.parse("#{params[:date]} 08:00")
        closing_time = Time.zone.parse("#{params[:date]} 22:00")

        bookings = court.bookings
                        .where("DATE(starts_on) = ?", params[:date])
                        .order(:starts_on)

        available_times = []
        current_time = opening_time

        while current_time < closing_time
          next_time = current_time + 1.hour

          slot_occupied = bookings.any? do |booking|
            booking.starts_on < next_time && booking.ends_on > current_time
          end

          available_times << { start: current_time, end: next_time } unless slot_occupied
          current_time = next_time
        end

        {
          court_id: court.id,
          date: params[:date],
          available_times: available_times.map do |time|
            {
              start: time[:start].strftime('%H:%M'),
              end: time[:end].strftime('%H:%M')
            }
          end
        }
      end
    end
  end
end
