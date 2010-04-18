class Pool
  def initialize(members)
    @members = members.shuffle
    @max = max_chance
  end
  
  def self.fill(roster, members, &block)
    pool = new(members)
    pool.fill(roster, &block)
  end
  
  def fill(roster)
    if @members.length > 0 && @max > 0
      
      @members.each do |m| 
        m.do_duty = get_initial_do_duty(m)  
      end

      @i = 0
      
      roster.roster_days.each do |day|
        slots = day.roster_slots.select { |rs| yield(rs) }
        slots.each do |slot|
          slot.update_attributes! :member => get_next_person
        end
      end
    end
  end
  
  private 
  
  def get_next_person
    DBC.require(@members.length > 0)
    DBC.require(@max > 0)
    
    result = nil
    
    while !result
      temp = @members[@i]
      if temp.do_duty >= 100
        temp.do_duty -= 100
        result = temp
      end
      temp.do_duty += normalized_chance_of_duty(temp)
      @i = (@i + 1) % @members.length
    end
    
    result
  end
  
  def max_chance
    if @members.length > 0
      @members.max {|a, b| a.chance_of_doing_duty <=> b.chance_of_doing_duty}.chance_of_doing_duty
    else
      0
    end
  end
  
  def get_initial_do_duty(member)
    DBC.require(member)
    DBC.require(@max)
    
    normalized_chance_of_duty(member) + 50
  end
  
  def normalized_chance_of_duty(member)
    DBC.require(member)
    DBC.require(@max)

    (100.0 / @max) * member.chance_of_doing_duty
  end
  
  
end