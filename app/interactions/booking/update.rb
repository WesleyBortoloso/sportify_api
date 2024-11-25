class Booking::Update < BaseInteraction
  attr_reader :booking

  def call
    fetch_booking!
    update_booking!

    booking
  end

  private

  def update_booking!
    booking.update(params)
  end

  def fetch_booking!
    @booking ||= Booking.find(params[:id])
  end
end
