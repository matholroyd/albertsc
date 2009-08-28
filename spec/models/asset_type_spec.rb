require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AssetType do
  
  it 'must have a unique name' do
    AssetType.make(:name => 'key').should be_valid
    AssetType.make_unsaved(:name => 'key').should have(1).error_on(:name)
  end
  
  it 'should require invoice_fee if invoiceable' do
    AssetType.make_unsaved(:invoiceable => true, :invoice_fee => nil).should have(1).error_on(:invoice_fee)
  end

end
