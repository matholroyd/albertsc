class RosterScheduler
  def plan_roster(dates, options = {})
    options[:ood_slots] ||= 1
    # options[:licensed_crew_slots] ||= 2
    # options[:unlicensed_crew_slots] ||= 3
    
    
    days = dates.length
    
    # licensed_crew_slots = days * options[:licensed_crew_slots]
    # unlicensed_crew_slots = days * options[:unlicensed_crew_slots]

    oods = Member.active.qualified_for_ood
    ood_pool = get_pool(oods, days * options[:ood_slots])
    
    result = Roster.create!
    dates = dates.reverse
    rd = nil

    ood_pool.each_with_index do |ood, i|
      if i % options[:ood_slots] == 0
        rd = result.roster_days.create! :date => dates.pop
      end
      
      DBC.assert(rd, "i => #{i}")
      
      rd.roster_slots.create! :member => ood
    end
    
    result.reload
    result
  end
  
  private 
  
  def get_pool(members, length)
    pool = []

    if members.length > 0 && max_chance(members) > 0
      max = max_chance(members)
      
      (rand(2) + 2).times { members.shuffle! }

      i = 0
      members.each { |m| m.do_duty = (100.0 / max) * m.chance_of_doing_duty + 50 }
    
      while pool.length < length
        m = members[i]
        if m.do_duty >= 100
          m.do_duty -= 100
          pool << m 
        end
      
        m.do_duty += (100.0 / max) * m.chance_of_doing_duty
      
        i = (i + 1) % members.length
      end
    end
    
    pool
  end

  def max_chance(members)
    members.max {|a, b| a.chance_of_doing_duty <=> b.chance_of_doing_duty}.chance_of_doing_duty
  end
  
end
