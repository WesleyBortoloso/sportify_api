class Booking::UserJoin < BaseInteraction
  attr_reader :booking

  def call
    fetch_booking!
    insert_user_in_booking!

    booking
  end

  private

  def insert_user_in_booking!
    booking.players.create!(nickname: current_user.name, user_id: current_user.id)
  end

  def fetch_booking!
    @booking ||= Booking.find(params[:id])
  end
end
