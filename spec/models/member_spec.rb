require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Member do
   
  it 'should have assets' do
    m = Member.make
    m.assets.create :details => "laser", :asset_type_id => AssetType::Boat.id
    b = m.assets.first
    b.should be_valid
  end
   
  it 'should have associated_members' do
    m = Member.make
    am = m.associated_members.create :first_name => 'bob'
    am.should be_valid
  end
  
  it 'should return the joined names' do
    Member.make(:first_name => 'Boblet', :last_name => 'Smith', :preferred_name => 'Bob').name.should == 'Bob Smith'
  end
  
  describe 'states' do
    it 'should default to active state' do
      Member.make.should be_active
    end
    
    it 'should transition to resigned' do
      Member.make.resign!
    end
    
    it 'should be using the status columns, not state' do
      m = Member.make(:state => 'VIC')
      
      m = Member.find(m.id)
      m.state.should == 'VIC'
      m.should be_active
    end
  end
  
  describe 'named scopes' do 
    before :each do
      @active = Member.make
      @resigned = Member.make
      @resigned.resign!
      @associated = Member.make(:associated_member => @active)
    end
    
    it 'should have active' do
      Member.active.should == [@active, @associated]
    end

    it 'should have principals' do
      Member.principals.should == [@active, @resigned]
    end
    
    it 'should combine active and principal' do
      Member.active.principals.should == [@active]
    end

  end
    
 
end
