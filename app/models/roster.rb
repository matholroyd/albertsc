class Roster < ActiveRecord::Base
  validates_presence_of :start_on, :finish_on
end
