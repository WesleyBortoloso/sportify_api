class Booking::Create < BaseInteraction
  attr_reader :booking, :enriched_params, :share_token

  def call
    generate_share_token!
    enrich_params!
    create_booking!
    insert_user_as_a_player!

    booking
  end

  private

  def generate_share_token!
    @share_token = SecureRandom.hex(10)
  end

  def create_booking!
    @booking = Booking.create!(enriched_params)
  end

  def enrich_params!
    @enriched_params ||= params.merge(user_id: current_user.id, share_token: share_token, ends_on: ends_on, total_value: court.price)
  end

  def insert_user_as_a_player!
    booking.players.create!(nickname: current_user.name)
  end

  def ends_on
    params[:starts_on] + 1.hour
  end

  def court
    @court ||= Court.find(params[:court_id])
  end
end
