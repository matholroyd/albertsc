
task :deploy do
  %x{git push origin master}
  %x{git push heroku master}
end

namespace :live do

  task :backup do
    puts %x{mkdir backups} unless File.exists?('backups')
    puts %x{mv albertsc.tar.gz backups/albertsc-#{DateTime.now.strftime("%a-%m-%B--%I-%M-%p")}.tar.gz}
  end

  
end

