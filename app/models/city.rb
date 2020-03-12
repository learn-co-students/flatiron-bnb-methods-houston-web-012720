class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, through: :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(date1, date2)
    self.listings.select{ |listing|
      !listing.occupied?(date1, date2)
    }
  end

  def ratio_res_to_listing
    self.reservations.count / self.listings.count
  end

  def self.highest_ratio_res_to_listings
    City.all.max_by { |city|
      city.ratio_res_to_listing
    }
  end

  def self.most_res
    City.all.max_by { |city|
      city.reservations.count
    }
  end
  
end

