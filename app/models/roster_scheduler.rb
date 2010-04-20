class RosterScheduler
  def plan_roster(dates, options = {})
    options[:ood_slots] ||= 0
    options[:licensed_crew_slots] ||= 0
    options[:unlicensed_crew_slots] ||= 0
    
    days = dates.length

    roster = Roster.create!
    dates.each { |date| roster.roster_days.create! :date => date }
  
    pool = Pool.new(Member.active.qualified_for_ood)
    
    create_roster_slots(roster.roster_days, options[:ood_slots]) do |rs|
      rs.require_qualified_for_ood = true
      rs.member = pool.get_next_person
    end
    
    pool = Pool.new(pool.members | Member.active.powerboat_licence)
    
    create_roster_slots(roster.roster_days, options[:licensed_crew_slots]) do |rs|
      rs.require_powerboat_licence = true
      rs.member = pool.get_next_person
    end

    pool = Pool.new(pool.members | Member.active.no_powerboat_licence)

    create_roster_slots(roster.roster_days, options[:unlicensed_crew_slots]) do |rs|
      rs.member = pool.get_next_person
    end
    
    
    # dates.each do |d|  
    #   rd = roster.roster_days.create! :date => d 
    #   
    #   options[:ood_slots].times { rd.roster_slots.create! :require_qualified_for_ood => true }
    #   options[:licensed_crew_slots].times { rd.roster_slots.create! :require_powerboat_licence => true }
    #   options[:unlicensed_crew_slots].times { rd.roster_slots.create! }
    # end
    # 
    # Pool.fill(roster, Member.active.qualified_for_ood) { |roster_slot| roster_slot.require_qualified_for_ood? }
    # Pool.fill(roster, Member.active.powerboat_licence) { |roster_slot| roster_slot.require_powerboat_licence? }
    # Pool.fill(roster, Member.active.no_powerboat_licence) { |roster_slot| !roster_slot.require_powerboat_licence? && !roster_slot.require_qualified_for_ood }

    roster.reload
    roster
  end 
  
  private 
  
  def create_roster_slots(roster_days, slots) 
    roster_days.each do |rd|
      slots.times do
        roster_slot = rd.roster_slots.build 
        yield(roster_slot)
        roster_slot.save!
      end
    end
  end
  
end
