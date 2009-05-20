class User < ActiveRecord::Base
  acts_as_authentic
  
  validates_presence_of :first_name, :last_name
  
  def name
    [first_name, last_name].reject(&:blank?).join(' ')
  end
end
