class Player < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :booking
end
