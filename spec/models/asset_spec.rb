require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Asset do

  it 'should create a valid asset' do
    Asset.make
  end

  [:member_id, :asset_type_id, :details].each do |field|
    it "must have #{field}" do
      Asset.make_unsaved(field => nil).should have(1).error_on(field)
    end
  end
  
  it 'can set asset_type' do
    Asset.make(:asset_type => AssetType.make).should be_valid
  end

end
