class Asset < ActiveRecord::Base
  belongs_to :member
  belongs_to :asset_type

  validates_presence_of :member_id, :asset_type_id, :details
  
  named_scope :invoiceable, :include => [:asset_type], :conditions => ['asset_types.invoiceable = ?', true]
  named_scope :boats, :include => [:asset_type], :conditions => ['asset_types.name = ?', 'Boat']
  named_scope :racks, :include => [:asset_type], :conditions => ['asset_types.name LIKE ?', 'Rack%']
  named_scope :keys, :include => [:asset_type], :conditions => ['asset_types.name = ?', 'Key']
end
