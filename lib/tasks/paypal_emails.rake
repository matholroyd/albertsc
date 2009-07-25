namespace :import do
  task :paypal_emails => :environment do
    PaypalEmail.import_pending
  end
end