require File.dirname(__FILE__) + '/../../config/boot'
require File.dirname(__FILE__) + '/../../config/environment'

def create_user(attributes)
  User.create!(attributes) unless User.exists?(:email => attributes[:email])
end

namespace :db do
  desc "Bootstraps the database"
  task :bootstrap do
    create_user(:email => 'me@home.com',
      :password               => 'secret',
      :password_confirmation  => 'secret'
    )    
  end
  
  task :import => [:environment] do
    Importing.import_from_file(open('/Users/matholroyd/Desktop/DataArchive/export.xml'))
  end
end



