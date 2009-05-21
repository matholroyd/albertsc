class Member < ActiveRecord::Base
  belongs_to :membership_type
  belongs_to :associated_member, :class_name => 'Member', :foreign_key => 'associated_member_id'
  has_many :associated_members, :class_name => 'Member', :foreign_key => 'associated_member_id'
  has_many :assets, :dependent => :destroy

  before_validation :set_name
  
  validates_presence_of :name 
   
  acts_as_state_machine :column => :status, :initial => :active
  
  state :active
  state :resigned
  
  event :resign do
    transitions :from => :active, :to => :resigned 
  end
  
  named_scope :active, :conditions => {:status => 'active'}
  named_scope :resigned, :conditions => {:status => 'resigned'}
  named_scope :principals, :conditions => {:associated_member_id => nil}
  
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
  
  private 
  
  def set_name
    first = preferred_name.blank? ? first_name : preferred_name
    self.name = [last_name, first].reject(&:blank?).join(', ')
  end
  
end
