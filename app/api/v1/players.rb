module V1
  class Players < Grape::API
    resource :players do
      # POST /players/:share_token
      desc 'Create a new player for a booking using a share token'
      params do
        requires :nickname, type: String, desc: 'Nickname of the player'
        requires :role, type: String, desc: 'Role of the player'
      end

      post ':share_token' do
        player = Player::Create.call(params)
        PlayerSerializer.new(player)
      end
    end
  end
end
