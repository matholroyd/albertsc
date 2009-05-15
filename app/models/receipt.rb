class Receipt < ActiveRecord::Base
  validates_presence_of :member_id
end
