require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Member do
   
  it 'should create a boat' do
    m = Member.make
    m.assets.create :details => "laser", :asset_type_id => AssetType::Boat.id
    b = m.assets.first
    b.should be_valid
  end
 
end
