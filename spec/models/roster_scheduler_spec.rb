require 'spec_helper'

describe RosterScheduler do
  before :each do
    @rs = RosterScheduler.new
  end

  describe 'with 1 day to fill but no one available' do
    before :each do
      @dates = [1.day.from_now.to_date]
    end
    
    it 'should schedule no one' do
      @roster = @rs.plan_roster(@dates)
      @roster.roster_slots.should == []
    end
  end
  
  describe 'with 1 day and 1 ood person' do
    before :each do
      Member.make :qualified_for_ood => true
      @dates = [1.day.from_now.to_date]
    end
    
    it 'should schedule person once' do
      @roster = @rs.plan_roster(@dates, :ood_slots => 1)

      @roster.roster_days.length.should == 1
      @roster.roster_days.first.date.should == @dates.first
    end
  end


end
