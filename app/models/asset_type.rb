class AssetType < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
    
  def self.selections
    all.collect {|r| [r.name, r.id]}
  end
end