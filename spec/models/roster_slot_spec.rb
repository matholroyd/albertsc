require 'spec_helper'

describe RosterSlot do
  before :each do
  end

  it "should create a new instance given valid attributes" do
    RosterSlot.make
  end
  
  [:roster_day_id].each do |field|
    it "should require #{field}" do
      RosterSlot.make_unsaved(field => nil).should have(1).error_on(field)
    end
  end
end
