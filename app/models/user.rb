class User < ApplicationRecord
  ROLES = %w[user admin].freeze
  has_many :bookings

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  validates :role, inclusion: { in: ROLES }

  def admin?
    role == 'admin'
  end

  def user?
    role == 'user'
  end

  def jwt_subject
    id
  end
end
