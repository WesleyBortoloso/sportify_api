class Player::Create < BaseInteraction
  attr_reader :player, :booking

  def call
    fetch_booking!
    ensure_court_max_players
    create_player!

    player
  end

  private

  def fetch_booking!
    @booking ||= Booking.find_by(share_token: params[:share_token])
  end

  def ensure_court_max_players
    return if booking.players.count >= booking.court.max_players
  end

  def create_player!
    @player = booking.players.create!(nickname: params[:nickname], role: params[:role])
  end
end
