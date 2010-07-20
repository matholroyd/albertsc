require 'spec_helper'

describe Feedback do
  
  it 'should create a feedback with no errors' do
    Feedback.make
  end
  
  [:what_is_the_reason_for_leaving, :what_did_you_like_most, :what_do_you_suggest_should_change,
  :any_other_tips_for_the_club].each do |field|
    it "should require at least one field, such as #{field}" do
      f = Feedback.new 
      f.valid?
      f.should_not be_valid
      f.update_attributes field => 'some text'
      f.should be_valid
    end
  end
end
