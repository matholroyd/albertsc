class Receipt < ActiveRecord::Base
  belongs_to :member
  
  validates_presence_of :member_id, :receipt_number, :payment_expires_on, :amount 
end
