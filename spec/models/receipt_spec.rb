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
  
  it 'should force an update of the related member' do
    r = Receipt.make(:payment_expires_on => 1.year.ago.to_date)
    r.member.should_not be_financial
    
    r.payment_expires_on = 1.year.from_now.to_date
    r.save
    r.member.should be_financial
  end

end
