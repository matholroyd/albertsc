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
  
  it 'should require name' do
    Member.make_unsaved(:first_name => '', :last_name => '', :preferred_name => '').should have(1).error_on(:name)
  end

  describe 'setting name' do
    it 'should return the joined names' do
      Member.make(:first_name => 'Boblet', :last_name => 'Smith', :preferred_name => 'Bob').name.should == 'Smith, Bob'
    end

    it 'should return the first names' do
      Member.make(:first_name => 'Boblet', :last_name => '', :preferred_name => '').name.should == 'Boblet'
    end

    it 'should return the preferred_name' do
      Member.make(:first_name => '', :last_name => '', :preferred_name => 'Bob').name.should == 'Bob'
    end
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

  describe 'navigation aids' do
    before :each do
      @a = Member.make(:last_name => 'aaaa')
      @b = Member.make(:last_name => 'bbbb')
      @c = Member.make(:last_name => 'cccc')
    end
    
    it 'should return the previous member' do
      @a.previous.should == nil
      @b.previous.should == @a
      @c.previous.should == @b
    end

    it 'should return the next member' do
      @a.next.should == @b
      @b.next.should == @c
      @c.next.should == nil
    end

    describe 'named_scoped' do    
      it 'should accept named_scope params' do
        @b.resign!
        
        @c.previous(:active).should == @a
        @a.next(:active).should == @c
      end
      
      it 'should accept multime named_scopes' do
        @a.update_attributes(:associated_member_id => @c.id)
        @b.resign!
        @ab = Member.make(:last_name => 'aabb')
        
        @c.previous(:active, :principals).should == @ab
        @c.next(:active, :principals).should == nil
      end
      
    end
  end
 
end
