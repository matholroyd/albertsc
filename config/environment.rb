# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.load_paths += Dir["#{RAILS_ROOT}/app/models/*/*"]
  
  config.gem 'mbleigh-acts-as-taggable-on', :lib => 'acts-as-taggable-on', :source => 'http://gems.github.com'
  config.gem 'haml'
  config.gem 'faker'
  config.gem 'authlogic'
  config.gem 'hpricot'
  config.gem 'machinist'
  config.gem 'tworgy-ruby'
  config.gem 'tworgy-rails'
  

  config.time_zone = 'UTC'
  config.active_record.timestamped_migrations = false
end

require 'recursively'
require 'rails_extensions'
require 'imap_searcher'
require 'pdf/writer'
require 'pdf/simpletable'

App = YAML.load(File.read(RAILS_ROOT + "/config/config.yml"))[RAILS_ENV].recursively!(&:symbolize_keys)
