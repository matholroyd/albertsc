
task :deploy do
  %x{git push origin master}
  %x{git push heroku master}
end