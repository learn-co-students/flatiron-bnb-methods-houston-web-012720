class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings


  def neighborhood_openings(date1, date2)
    self.listings.select{ |listing|
      !listing.occupied?(date1, date2)
    }
  end

  def ratio_res_to_listing
    self.reservations.count / self.listings.count rescue 0
  end

  def self.highest_ratio_res_to_listings
    Neighborhood.all.max_by { |n|
      n.ratio_res_to_listing
    }
  end

  def self.most_res
    Neighborhood.all.max_by { |n|
      n.reservations.count
    }
  end
end
