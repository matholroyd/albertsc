require 'spec_helper'

describe Roster do
  before :each do
  end

  it "should create a new instance given valid attributes" do
    Roster.make
  end  
  
  describe 'filling roster' do
    before :each do
      @r = Roster.make
      @d1 = RosterDay.make(:roster => @r, :date => 2.day.from_now.to_date)
      @d2 = RosterDay.make(:roster => @r, :date => 1.day.from_now.to_date)
      @d3 = RosterDay.make(:roster => @r, :date => 3.day.from_now.to_date)
      @r.reload
    end
     
    it 'should have a bunch of days in order' do
      @r.roster_days.should == [@d2, @d1, @d3]
    end
  end
end
