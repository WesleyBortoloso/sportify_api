class CourtSerializer
  include JSONAPI::Serializer

  set_type :court
  attributes :name, :max_players, :category, :description, :price, :status
end
