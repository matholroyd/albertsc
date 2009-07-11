require File.dirname(__FILE__) + '/../../config/boot'
require File.dirname(__FILE__) + '/../../config/environment'

def create_user(attributes)
  User.create!(attributes) unless User.exists?(:email => attributes[:email])
end

namespace :db do
  desc "Bootstraps the database"
  task :bootstrap do
    create_user(:email => 'me@home.com',
      :first_name => 'dummy',
      :last_name => 'user',
      :password               => 'secret',
      :password_confirmation  => 'secret'
    )
    
    %w{ Key YV/YA_Membership_Number Boat Rack_Top Rack_Middle Rack_Bottom Rack_Minnow }.each do |name|
      AssetType.create :name => name.titleize
    end
  end
  
  namespace :import do
    task :members => :environment do
      Importing.import_members_from_file(open('/Users/matholroyd/Desktop/DataArchive/export.xml'))
    end
    
    task :update_receipts =>:environment do
      Importing.update_receipts_from_file(open('/Users/matholroyd/Desktop/test.xml'))
    end
  end
end



