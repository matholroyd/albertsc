
task :deploy do
  %x{git push origin master}
  %x{git push heroku master}
end

namespace :live do

  task :backup do
    puts %x{heroku bundles:destroy backup}
    puts %x{heroku bundles:capture backup}
    puts %x{heroku bundles:download}
    puts %x{mkdir backups} unless File.exists?('backups')
    puts %x{mv albertsc.tar.gz backups/albertsc-#{DateTime.now.strftime("%a-%m-%B--%I-%M-%p")}.tar.gz}
  end

  task :pull do
    puts %x{heroku db:pull}
  end

  task :push do
    puts %x{heroku db:push}
  end
  
end

