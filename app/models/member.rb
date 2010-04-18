class Member < ActiveRecord::Base
  belongs_to :membership_type
  belongs_to :associated_member, :class_name => 'Member', :foreign_key => 'associated_member_id'
  has_many :associated_members, :class_name => 'Member', :foreign_key => 'associated_member_id'
  has_many :assets, :dependent => :destroy
  has_many :receipts, :dependent => :destroy
  accepts_nested_attributes_for :assets, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
  accepts_nested_attributes_for :receipts, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  before_validation :set_name
  after_save :update_current_payment_expires_on
  
  validates_presence_of :name 
  
  attr_accessor :do_duty

  def validate
    if associated_member
      errors.add(:membership_type_id, 'should not be set if linked to another member') if membership_type

      if associated_member.membership_type != MembershipType::Family
        errors.add(:associated_member_id, 'cannot be set to a member without a family membership') 
      end
    else
      errors.add(:membership_type_id, 'should not be blank') unless membership_type_id
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

  def toggle_status!
    send(next_status_method + '!')
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
  named_scope :qualified_for_ood, :conditions => {:qualified_for_ood => true}
  
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
    
  def self.comma_separated_value_columns
    %w{id title first_name last_name preferred_name name street_address_1 street_address_2 suburb_upcase
      suburb_downcase state_upcase state_downcase postcode country membership_type date_of_birth 
      joined_on email spouse_name
      phone_home phone_work phone_mobile emergency_contact_name_and_number occupation special_skills sex 
      powerboat_licence status created_at updated_at financial? current_payment_expires_on registered_boats 
      registered_racks keys
      }
  end  
    
  def comma_separated_values
    Member.comma_separated_value_columns.collect { |c| replace_commas(send(c)) }.join(',')
  end
  
  def invoice_fee
    result = membership_type.fee
    assets.invoiceable.each do |asset| 
      result += asset.asset_type.invoice_fee
    end
    result
  end
  
  def registered_boats
    assets.boats.collect(&:details).join(', ')
  end
  
  def registered_racks
    assets.racks.collect(&:details).join(', ')
  end
  
  def keys
    assets.keys.collect(&:details).join(', ')
  end
  
  def suburb_upcase
    suburb.upcase if suburb
  end
  
  def suburb_downcase
    suburb.downcase.humanize if suburb
  end
  
  def state_upcase
    state.upcase if state
  end
  
  def state_downcase
    state.downcase.humanize if state
  end
  
  def financial?
    if current_payment_expires_on
      current_payment_expires_on >= Date.today
    else
      false
    end
  end
  
  def last_receipt(reload = false)
    self.receipts(reload).find(:first, :order => 'payment_expires_on DESC')
  end
  
  def update_current_payment_expires_on
    receipt = last_receipt(true)
    if receipt
      self.current_payment_expires_on = receipt.payment_expires_on
      Member.update_all("current_payment_expires_on = '#{current_payment_expires_on.to_s}'", "id = #{id}")
    end
    
    true
  end
  
  private 
  
  def replace_commas(field)
    field.to_s.gsub(/,/, ';').gsub(/\n/, ' ')
  end
  
  def set_name
    first = preferred_name.blank? ? first_name : preferred_name
    self.name = [last_name, first].reject(&:blank?).join(', ')
  end
  
end
