class Court < ApplicationRecord
  has_many :bookings, dependent: :destroy

  enum category: {
    soccer: 'soccer',
    padel: 'padel'
  }

  enum status: {
    open: 'open',
    closed: 'closed'
  }
end
