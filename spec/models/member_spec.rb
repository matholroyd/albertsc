require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Member do
   
  it 'should have assets' do
    m = Asset.make.member
    b = m.assets.first
    b.should be_valid
  end
  
  it 'should return the method needed to toggle the status' do
    m = Member.make
    m.should be_active
    m.next_status_method.should == 'resign'
    m.resign!
    m.next_status_method.should == 'activate'
  end
  
  describe 'comma seperated values' do
    it 'should not have any errors' do
      Member.make.comma_separated_values
    end
  end
  
  describe 'associated members'  do
    it 'can associate with a member with a family membership' do
      f = Member.make(:membership_type => MembershipType.find_by_name('Family'))
      Member.make(:associated_member => f, :membership_type => nil)
    end
    
    it 'cannot associate with a non-family membership member' do
      f = Member.make(:membership_type => MembershipType.find_by_name('Senior'))
      Member.make_unsaved(:associated_member => f).should have(1).error_on(:associated_member_id)
    end
  
    it 'should have a membership type if not linked to other member' do
      m = Member.make_unsaved(:membership_type => nil).should have(1).error_on(:membership_type_id)
    end
  
    it 'should have no membership type if linked to other member' do
      m = Member.make_unsaved(:associated_member => Member.make, :membership_type => MembershipType.find_by_name('Senior'))
      m.should have(1).error_on(:membership_type_id)
    end
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
  
  describe 'financial status' do
    it 'should be unfinancial if have no receipts' do
      Member.make.should_not be_financial
    end
    
    it 'should be unfinancial if only has out-of-date receipts' do
      r = Receipt.make(:payment_expires_on => 1.day.ago)
      r.member.should_not be_financial
    end
    
    it 'should be financial if have at least one receipt that is not out-of-date' do
      m = Receipt.make(:payment_expires_on => 1.day.ago).member
      Receipt.make(:member => m, :payment_expires_on => 1.day.from_now)
      
      m.save
      m.should be_financial
    end
  end
  
  describe 'total fee' do
    it 'should equal membership fee' do
      member = Member.make(:membership_type => MembershipType::Senior)
      member.invoice_fee.should == MembershipType::Senior.fee
    end
    
    it 'should sum the asset fee as well' do
      member = Member.make(:membership_type => MembershipType::Senior)
      member.assets.make(:asset_type => AssetType.make(:invoiceable => true, :invoice_fee => 100))
      member.invoice_fee.should == MembershipType::Senior.fee + 100
    end
  end
    
  describe 'named scopes' do 
    before :each do
      @active = Member.make(:membership_type => MembershipType::Family)
      @resigned = Member.make
      @resigned.resign!
      @associated = Member.make(:associated_member => @active, :membership_type => nil)
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
