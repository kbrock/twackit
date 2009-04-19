# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_twackit_session',
  :secret      => '6560aaff9265f5573d36e0cca5ed70b7908cccfc4033df0e27b6aae31450699da498b0cf7f91cf4fe2f8362332eb6bb3004c4088663ad4d395713183ee6329cb'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
