class Booking::AvailableTimes < BaseInteraction
  attr_reader :available_times, :bookings

  def call
    find_related_bookings!
    fetch_available_times!

    result
  end

  private

  def result
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

  def fetch_available_times!
    @available_times = []
    current_time = opening_time

    while current_time < closing_time
      next_time = current_time + 1.hour

      slot_occupied = bookings.any? do |booking|
        booking.starts_on < next_time && booking.ends_on > current_time
      end

      @available_times << { start: current_time, end: next_time } unless slot_occupied
      current_time = next_time
    end
  end

  def find_related_bookings!
    @bookings ||= court.bookings
                       .where("DATE(starts_on) = ?", params[:date])
                       .order(:starts_on)
  end

  def court
    @court ||= Court.find(params[:id])
  end

  def opening_time
    @opening_time ||= Time.zone.parse("#{params[:date]} 08:00")
  end

  def closing_time
    @closing_time ||= Time.zone.parse("#{params[:date]} 22:00")
  end
end
