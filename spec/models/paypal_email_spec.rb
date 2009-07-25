require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PaypalEmail do
  it 'should require source' do
    PaypalEmail.make_unsaved(:source => nil).should have(1).error_on(:source)
  end
  
  it 'tmail is the tmail object of the source' do
    email = PaypalEmail.make
    email.tmail.body.should =~ /dummy@gmail.com/
  end
  
  it 'should get the email message_id' do
    email = PaypalEmail.make
    email.message_id.should == email.tmail.message_id
  end
  
  describe 'extracting receipt values' do
    it 'should get the amount'
    it 'should get the sent from email'
    it 'should get the membership type'
    it 'should get the payment_expires_on'
  end
end
