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
    
    result = Roster.new
    dates = dates.reverse

    ood_pool.each_with_index do |ood, i|
      if i % options[:ood_slots] == 0
        rd = result.roster_days.build :date => dates.pop
      end
      
      rd.roster_slots.build :member => ood
    end
    
    result
  end
  
  private 
  
  def get_pool(members, length)
    pool = []

    if members.length > 0 
      (rand(2) + 2).times { members.shuffle! }

      i = 0
      members.each { |m| m.do_duty = m.chance_of_doing_duty + 50 }
    
      while pool.length < length
        m = members[i]
        pool << m if m.do_duty >= 100
      
        m.do_duty += m.chance_of_doing_duty
      
        i += 1
        i = i % members.length
      end
    end
    
    pool
  end
end