require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AssetType do
  
  it 'must have a unique name' do
    AssetType.make(:name => 'key').should be_valid
    AssetType.make_unsaved(:name => 'key').should have(1).error_on(:name)
  end

end
