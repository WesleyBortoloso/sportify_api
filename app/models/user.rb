class User < ApplicationRecord
  has_many :bookings
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  def jwt_subject
    id
  end
end
