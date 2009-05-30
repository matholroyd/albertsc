require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Receipt do
  it 'should build successful' do
    Receipt.make
  end
  
  [:amount, :receipt_number, :payment_expires_on].each do |field|
    it "should require #{field}" do
      Receipt.make_unsaved(field => nil).should have(1).error_on(field)
    end
  end

end
