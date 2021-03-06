require 'spec_helper'

describe RosterDay do
  before :each do
  end

  it "should create a new instance given valid attributes" do
    RosterDay.make
  end
  
  
  [:roster_id, :date].each do |field|
    it "should require #{field}" do
      RosterDay.make_unsaved(field => nil).should have(1).error_on(field)
    end
  end
  
end
