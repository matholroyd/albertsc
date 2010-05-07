class AssetType < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :invoice_fee, :if => Proc.new { |at| at.invoiceable? }
    
  def self.selections
    all.collect {|r| [r.name, r.id]}
  end
  
  named_scope :invoiceable, :conditions => {:invoiceable => true}
  named_scope :boats, :conditions => {:name => 'Boat'}
  named_scope :racks, :conditions => ['name LIKE ?', 'Rack%']
end