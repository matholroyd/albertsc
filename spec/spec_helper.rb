ENV['RAILS_ENV'] = 'test'

require File.expand_path(File.dirname(__FILE__) + '/../config/environment')
require File.expand_path(File.dirname(__FILE__) + '/blueprints')
require 'spec/autorun'
require 'spec/rails'
require 'authlogic/test_case'

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  config.before(:each) do
    Sham.reset 
    activate_authlogic
  end
end

def content_for(name)
  response.template.instance_variable_get("@content_for_#{name}")
end
