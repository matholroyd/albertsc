class Roster < ActiveRecord::Base
  has_many :roster_days
  has_many :roster_slots, :through => :roster_days
  
end
