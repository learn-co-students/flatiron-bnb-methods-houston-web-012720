class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validate :has_neighborhood

  def has_neighborhood
    if !self.neighborhood
      errors.add(:neighborhood_id, "can't be blank")
    end
  end

  def occupied?(date1, date2)
    self.reservations.any?{ |r|
      r.starts?(date1, date2) || r.ends?(date1, date2) || r.overlaps?(date1, date2)
    }
  end

  def average_review_rating
    
    self.reviews.reduce(0.0){ |sum, review|
      sum += review.rating
    }/self.reviews.count
  end
  
end
