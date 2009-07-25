
task :deploy do
  %x{git push origin master}
  %x{git push heroku master}
end

namespace :live do

  task :backup do
    puts %x{heroku bundles:download}
    puts %x{heroku bundles:destroy backup}
    puts %x{heroku bundles:capture backup}
  end

  task :download do
    puts %x{heroku db:pull}
  end
  
end

