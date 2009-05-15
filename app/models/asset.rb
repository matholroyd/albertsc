class Asset < ActiveRecord::Base
  validates_presence_of :member_id
end
