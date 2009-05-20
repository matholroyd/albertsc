require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do

  [:first_name, :last_name].each do |field|
    it "should require the #{field}" do
      user = User.make_unsaved(field => '').should have(1).error_on(field)
    end
  end

end
