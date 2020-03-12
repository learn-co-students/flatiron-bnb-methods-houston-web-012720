class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :is_both_dates_valid?
  validate :is_not_own?
  validate :occupied?
  before_validation :correct_dates

  def is_not_own?
    # puts "#{self.guest_id} #{self.listing.host_id}"
    self.guest_id != self.listing.host_id
  end

  def occupied?
    if self.listing.occupied?(self.checkin, self.checkout)
      errors.add("#{self.listing.title}", "Listing occupied that dates")
      return true
    end
  end

  def is_both_dates_valid?
    if !(self.checkin && self.checkout)
      errors.add(:checkin, "there must be 2 dates")
    elsif !(self.checkin && self.checkin.to_date rescue nil)
      errors.add(:checkin, "should be a date!")
    elsif !(self.checkout && self.checkout.to_date rescue nil)
      errors.add(:checkout, "should be a date!")
    elsif (self.checkout.to_date <= self.checkin.to_date)
      errors.add(:checkout, "Checkout m=st be after Checkin!")

    end
  end

  def total_price
    self.listing.price * self.duration
  end

  def duration
    r = self.checkout - self.checkin
  end

  def correct_dates
    begin
      self.checkin = self.checkin.to_date
      self.checkout = self.checkout.to_date
    rescue
      nil
    end
  end

  def starts?(date1, date2)
    self.checkin.between?(date1.to_date, date2.to_date) rescue true
  end

  def ends?(date1, date2)
    self.checkout.between?(date1.to_date, date2.to_date) rescue true
  end

  def overlaps?(date1, date2)
    (self.checkout > date2.to_date) && (self.checkin < date1.to_date) rescue true
  end

end

# r = Reservation.new(checkin: "01.02.2015", checkout: "01.02.2015", status: "test")
  
