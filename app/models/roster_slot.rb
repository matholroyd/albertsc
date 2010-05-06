class RosterSlot < ActiveRecord::Base
  belongs_to :roster_day
  belongs_to :member
  
  validates_presence_of :roster_day_id, :member_id
  
  def validation
    valid_member?(self)
  end
  
  def valid_member?(member)
    (!require_qualified_ood || member.qualified_for_ood) && 
    (!require_powerboat_license || member.powerboat_licence)
  end
end
