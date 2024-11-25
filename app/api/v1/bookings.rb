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
        optional :page, type: Integer, default: 1, desc: 'Page number'
        optional :per_page, type: Integer, default: 6, desc: 'Items per page'
      end

      get do
        bookings = Booking.ransack(params[:filter]).result.page(params[:page]).per(params[:per_page])
        BookingSerializer.new(
          bookings,
          meta: {
            current_page: bookings.current_page,
            total_pages: bookings.total_pages,
            total_count: bookings.total_count
          }
        )
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

      # GET /bookings/:id/available_times
      desc 'List all availables hours related for a court'
      params do
        requires :id, type: Integer, desc: 'Court ID'
        optional :date, type: Date, desc: 'Wanted date', default: Date.today
      end

      get ':id/available_times' do
        Booking::AvailableTimes.call(declared(params))
      end

      # POST /bookings/:id/join
      desc 'Join into public booking'
      params do
        requires :id, type: Integer, desc: 'Booking ID'
      end

      post ':id/join' do
        booking = Booking::UserJoin.call(declared(params), current_user: current_user)
        BookingSerializer.new(booking)
      end
    end
  end
end
