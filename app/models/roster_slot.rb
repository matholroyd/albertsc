class RosterSlot < ActiveRecord::Base
  belongs_to :roster_day
  belongs_to :member
  
  validates_presence_of :roster_day_id, :member_id
end
