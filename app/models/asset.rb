class Asset < ActiveRecord::Base
  belongs_to :member
  belongs_to :asset_type

  validates_presence_of :member_id, :asset_type_id, :details
end
