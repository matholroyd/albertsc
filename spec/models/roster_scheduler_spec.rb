require 'spec_helper'

describe RosterScheduler do
  before :each do
    srand = 1
    @rs = RosterScheduler.new
  end
  
  describe 'with 0 day to fill' do
    before :each do
      @dates = []
    end
    
    it 'should schedule no days and no one' do
      Member.make :qualified_for_ood => true
      @roster = @rs.plan_roster(@dates, :ood_slots => 1)
      
      @roster.roster_days.should == []
      @roster.roster_slots.should == []
    end
    
  end

  describe 'with 1 day to fill' do
    before :each do
      @dates = [1.day.from_now.to_date]
    end
    
    it 'should schedule no one' do
      @roster = @rs.plan_roster(@dates)
      @roster.roster_slots.should == []
    end

    it 'should schedule 1 person once' do
      Member.make :qualified_for_ood => true
      @roster = @rs.plan_roster(@dates, :ood_slots => 1)

      @roster.roster_days.length.should == 1
      @roster.roster_days.first.date.should == @dates.first
    end

    it 'should schedule 3 people once' do
      3.times { Member.make :qualified_for_ood => true }
      @roster = @rs.plan_roster(@dates, :ood_slots => 3)

      @roster.roster_days.length.should == 1
      @roster.roster_days.first.roster_slots.length.should == 3
    end
  end

  describe 'with 3 days to fill' do
    before :each do
      @dates = (1..3).collect {|i| i.days.from_now.to_date }
    end
    
    it 'should schedule no one if no one available' do
      @roster = @rs.plan_roster(@dates)
      @roster.roster_slots.should == []
    end

    it 'should schedule 5 people 3 times' do
      5.times { Member.make :qualified_for_ood => true }
      @roster = @rs.plan_roster(@dates, :ood_slots => 5)

      @roster.roster_days.length.should == 3
      @roster.roster_days.each do |rd|
        rd.roster_slots.length.should == 5
      end
    end

    it 'should schedule based on percentage' do
      @m1 = Member.make :qualified_for_ood => true, :chance_of_doing_duty => 50
      @m2 = Member.make :qualified_for_ood => true, :chance_of_doing_duty => 100

      @roster = @rs.plan_roster(@dates, :ood_slots => 1)
      @roster.save
      @m1.reload
      @m2.reload
      
      @m1.roster_slots.length.should == 1
      @m2.roster_slots.length.should == 2
    end

  end


end
