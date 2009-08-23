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
    before :each do
      @pe = PaypalEmail.make
    end
    
    it 'should get the amount' do
      @pe.guessed_amount_paid.should == '369.50'
    end
    
    it 'should get the persons name' do
      @pe.guessed_name.should == 'MrDummy'
    end

    it 'should get the sent from email' do
      @pe.guessed_email.should == 'dummy@gmail.com'
    end
    
    it 'should get the sent from email' do
      @pe.guessed_email.should == 'dummy@gmail.com'
    end
    
    it 'should get the membership type'
    it 'should get the payment_expires_on'
  end
  
  describe 'named_scopes' do
    before :each do
      @processed = PaypalEmail.make :transfered_money_out_of_paypal => true, :recorded_in_accounting_package => true
      @transfered = PaypalEmail.make :transfered_money_out_of_paypal => true, :recorded_in_accounting_package => false
      @recorded = PaypalEmail.make :transfered_money_out_of_paypal => false, :recorded_in_accounting_package => true
      @not_processed = PaypalEmail.make :transfered_money_out_of_paypal => false, :recorded_in_accounting_package => false
    end
    
    it 'processed' do
      PaypalEmail.processed.should == [@processed]
    end

    it 'not_processed' do
      PaypalEmail.not_processed.should include(@transfered)
      PaypalEmail.not_processed.should include(@recorded)
      PaypalEmail.not_processed.should include(@not_processed)
      PaypalEmail.not_processed.should_not include(@processed)
    end
    
    it 'not_processed handles nil' do
      p = PaypalEmail.make :transfered_money_out_of_paypal => nil, :recorded_in_accounting_package => nil
      PaypalEmail.not_processed.should include(p)
    end
    
  end
end
