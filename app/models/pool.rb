class Pool
  def initialize(members)
    @members = members.shuffle
    @max = max_chance
    @i = 0
    initialize_pool_duty
  end
  
  def members
    @members
  end
  
  def self.fill(roster, members, &block)
    pool = new(members)
    pool.fill(roster, &block)
  end
  
  def fill(roster)
    if @members.length > 0 && @max > 0
      roster.roster_days.each do |day|
        slots = day.roster_slots.select { |rs| yield(rs) }
        slots.each do |slot|
          slot.update_attributes! :member => get_next_person
        end
      end
    end
  end

  def get_next_person
    DBC.require(@members.length > 0)
    DBC.require(@max > 0)
    
    result = nil
    
    while !result
      temp = @members[@i]
      if temp.pool_duty >= 100
        temp.pool_duty -= 100
        result = temp
      end
      temp.pool_duty += normalized_chance_of_duty(temp)
      temp.aggregate_duty += normalized_chance_of_duty(temp)
      @i = (@i + 1) % @members.length
    end
    
    result
  end
  
  def initialize_pool_duty
    @members.each do |m| 
      unless m.aggregate_duty
        m.aggregate_duty = get_initial_aggregate_duty(m)
      end
      m.pool_duty = -m.aggregate_duty
    end
  end
  
  
  private 
    
  def max_chance
    if @members.length > 0
      @members.max {|a, b| a.chance_of_doing_duty <=> b.chance_of_doing_duty}.chance_of_doing_duty
    else
      0
    end
  end
  
  def get_initial_aggregate_duty(member)
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