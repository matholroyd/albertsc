class Member < ActiveRecord::Base
  belongs_to :membership_type
  belongs_to :associated_member, :class_name => 'Member', :foreign_key => 'associated_member_id'
  has_many :associated_members, :class_name => 'Member', :foreign_key => 'associated_member_id'
  has_many :assets, :dependent => :destroy
  
   
  acts_as_state_machine :column => :status, :initial => :active
  
  state :active
  state :resigned
  
  event :resign do
    transitions :from => :active, :to => :resigned 
  end
  
  named_scope :active, :conditions => {:status => 'active'}
  named_scope :resigned, :conditions => {:status => 'resigned'}
  named_scope :principals, :conditions => {:associated_member_id => nil}
  default_scope :order => 'last_name, first_name'
  
  def name
    first = preferred_name.blank? ? first_name : preferred_name
    [last_name, first].reject(&:blank?).join(', ')
  end
end
