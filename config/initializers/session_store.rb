# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_albertsc_internal_session',
  :secret      => 'af2e9a07b4c11ffd69037e31e4be1c18d38a07ab89863aa31d05c42f0b4b06ac069931302db57e8946671f9561f6fb65cc7c236e9eacc73c24edfba8b543099a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
