class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, presence: true
  validates :description, presence: true
  validate :happened_validation

  def happened_validation
    if !self.reservation
      errors.add(:reservation_id, "Reservation must be selecteed")
    elsif self.reservation.checkout > Time.new
      errors.add(:reservation_id, "Reservation checkout must be happened")
    elsif self.reservation.status != "accepted"
      errors.add(:reservation_id, "Reservation must be accepted")
    end
  end

end
