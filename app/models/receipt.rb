class Receipt < ActiveRecord::Base
  belongs_to :member
  belongs_to :paypal_email
  
  after_save :update_members_financial_status
  
  validates_presence_of :member_id, :receipt_number, :payment_expires_on, :amount 
  
  private 
  
  def update_members_financial_status
    member.update_current_payment_expires_on
  end
  
end
