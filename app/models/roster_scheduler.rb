class RosterScheduler
  def plan_roster(dates, options = {})
    options[:ood_slots] ||= 0
    options[:licensed_crew_slots] ||= 0
    options[:unlicensed_crew_slots] ||= 0
    
    days = dates.length

    roster = Roster.create!
    dates.each do |d|  
      rd = roster.roster_days.create! :date => d 
      
      options[:ood_slots].times { rd.roster_slots.create! :require_qualified_for_ood => true }
      options[:licensed_crew_slots].times { rd.roster_slots.create! :require_powerboat_licence => true }
      options[:unlicensed_crew_slots].times { rd.roster_slots.create! }
    end

    Pool.fill(roster, Member.active.qualified_for_ood) { |roster_slot| roster_slot.require_qualified_for_ood? }
    Pool.fill(roster, Member.active.powerboat_licence) { |roster_slot| roster_slot.require_powerboat_licence? }
    Pool.fill(roster, Member.active.no_powerboat_licence) { |roster_slot| !roster_slot.require_powerboat_licence? && !roster_slot.require_qualified_for_ood }

    roster.reload
    roster
  end
  
end
