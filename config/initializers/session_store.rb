# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_albertsc_i2_session',
  :secret      => 'bc9faf0837d69932b2d5d65afc28bfcb92a7d8ec55c61aad453bd108f470dfd49ff8d5e151a407c4b0b58747faef1ba5860c102fc65f3330b5c95f061807f999'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
