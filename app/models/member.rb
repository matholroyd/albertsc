class Member < ActiveRecord::Base
  belongs_to :membership_type
  belongs_to :associated_member, :class_name => 'Member', :foreign_key => 'associated_member_id'
  has_many :associated_members, :class_name => 'Member', :foreign_key => 'associated_member_id'
  has_many :assets, :dependent => :destroy
  has_many :receipts, :dependent => :destroy
  accepts_nested_attributes_for :assets, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
  accepts_nested_attributes_for :receipts, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  before_validation :set_name, :set_financial
  
  validates_presence_of :name 

  def validate
    errors.add(:membership_type_id, 'should not be set if linked to another member') if membership_type_id && associated_member_id
  
    if associated_member && (associated_member.membership_type != MembershipType::Family)
      errors.add(:associated_member_id, 'cannot be set to a member without a family membership') 
    end
  end
  
  acts_as_state_machine :column => :status, :initial => :active
  
  state :active
  state :resigned
  
  event :resign do
    transitions :from => :active, :to => :resigned 
  end
  
  event :activate do
    transitions :from => :resigned, :to => :active
  end

  def next_status_method
    if active?
      'resign'
    elsif resigned?
      'activate'
    else
      DBC.fail("Unexpected status => #{status}")
    end
      
  end
  
  named_scope :sorted, :order => 'name'
  named_scope :active, :conditions => {:status => 'active'}
  named_scope :resigned, :conditions => {:status => 'resigned'}
  named_scope :principals, :conditions => {:associated_member_id => nil}
  named_scope :family, :conditions => {:associated_member_id => nil, :membership_type_id => MembershipType::Family.id}
  
  named_scope :previous, lambda { |p| {:conditions => ['name < ?', p.name], :limit => 1, :order => 'name DESC'} }
  named_scope :next, lambda { |p| {:conditions => ['name > ?', p.name], :limit => 1, :order => 'name'} }
  

  def previous(*named_scopes)
    result = Member
    
    named_scopes.each do |ns|
      result = result.send(ns)
    end
    
    result.previous(self).first
  end
  
  def next(*named_scopes)
    result = Member
    
    named_scopes.each do |ns|
      result = result.send(ns)
    end
    
    result.next(self).first
  end
  
  def expire_info
    if current_payment_expires_on
      current_payment_expires_on.to_s(:long)
    else
      'no info'
    end
  end
  
  private 
  
  def set_financial
    receipt = self.receipts.find(:first, :order => 'payment_expires_on DESC')
    
    if receipt
      self.current_payment_expires_on = receipt.payment_expires_on
      self.financial = current_payment_expires_on >= Date.today
    else
      self.financial = false
    end
    
    true
  end
  
  def set_name
    first = preferred_name.blank? ? first_name : preferred_name
    self.name = [last_name, first].reject(&:blank?).join(', ')
  end
  
end
