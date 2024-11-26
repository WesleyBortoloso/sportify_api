class BookingSerializer
  include JSONAPI::Serializer

  set_type :booking
  attributes :starts_on, :ends_on, :total_value, :status, :share_token, :public

  attribute :user do |object|
    {
      id: object.user.id,
      email: object.user.email,
      name: object.user.name
    }
  end

  attribute :court do |object|
    {
      id: object.court.id,
      name: object.court.name,
      category: object.court.category,
      price: object.court.price,
      max_players: object.court.max_players
    }
  end

  attribute :players do |object|
    object.players.map do |player|
      {
        id: player.id,
        nickname: player.nickname,
        role: player.role
      }
    end
  end
end
