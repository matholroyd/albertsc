class RosterDay < ActiveRecord::Base
  belongs_to :roster
  has_many :roster_slots
  
  validates_presence_of :roster_id, :date
end
