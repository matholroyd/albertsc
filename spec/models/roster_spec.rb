require 'spec_helper'

describe Roster do
  before :each do
  end

  it "should create a new instance given valid attributes" do
    Roster.make
  end
  
  [:start_on, :finish_on].each do |field|
    it "should require #{field}" do
      Roster.make_unsaved(field => nil).should have(1).error_on(field)
    end
  end
  
  describe 'filling roster' do
    before :each do
      
    end
    
    it 'should have a bunch of days' do
      
    end
  end
end
