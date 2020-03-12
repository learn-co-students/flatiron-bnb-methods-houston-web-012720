class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :guests, :through => :reservations
  has_many :host_reviews, :through => :guests, source: :reviews #this one
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :visited_listings, through: :trips, :source=> :listing #, :foreign_key => 'listing_id'
  has_many :hosts, through: :visited_listings  #this one
  has_many :reviews, :foreign_key => 'guest_id'
  

  def host?
    if self.listings.count > 0
      return true
    end
    false
  end
end


