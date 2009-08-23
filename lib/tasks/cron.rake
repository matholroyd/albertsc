task :cron => :environment do
  PaypalEmail.import_pending
end