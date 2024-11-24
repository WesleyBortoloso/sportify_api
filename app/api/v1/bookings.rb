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
        optional :filter, type: Hash, desc: "JSON API filtering params"
        optional :sort, type: Hash, desc: "JSON API sorting params"
        optional :page, type: Hash, desc: "JSON API paging params"
      end

      get do
        bookings = Booking.all
        BookingSerializer.new(bookings, include: [:user, :court, :players])
      end
    end
  end
end
