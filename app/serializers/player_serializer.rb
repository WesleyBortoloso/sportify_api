class PlayerSerializer
  include JSONAPI::Serializer

  attributes :role, :nickname

  belongs_to :booking, serialier: BookingSerializer
end
