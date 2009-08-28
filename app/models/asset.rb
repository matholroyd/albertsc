class Asset < ActiveRecord::Base
  belongs_to :member
  belongs_to :asset_type

  validates_presence_of :member_id, :asset_type_id, :details
  
  named_scope :invoiceable, :include => [:asset_type], :conditions => ['asset_types.invoiceable = ?', true]
end
