require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Rails Extensions' do

  it 'should be able to get selections for a named scope' do
    m = Member.make(:membership_type => MembershipType::Family)
    Member.family.selections.should == [[m.name, m.id]]
  end

end
