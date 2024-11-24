class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :court

  has_many :players, dependent: :destroy

  validate :no_time_conflict

  def self.ransackable_attributes(auth_object = nil)
    %w[public starts_on status]
  end

  private

  def no_time_conflict
    conflicting_booking = Booking.where(court_id: court_id)
                                 .where.not(id: id)
                                 .where(
                                   '(starts_on, ends_on) OVERLAPS (?, ?)',
                                   starts_on, ends_on
                                 )
                                 .exists?

    errors.add(:base, 'Já existe uma reserva para este horário.') if conflicting_booking
  end
end
