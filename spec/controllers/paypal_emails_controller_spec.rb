require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PaypalEmailsController do
  integrate_views

  before :each do
    @user = User.make
    UserSession.create(@user)
  end
  
  describe 'get index' do
    it 'should repond with success' do
      get :index
      response.should be_success
    end
  end
  
  describe 'get check_for_new' do
    it 'should call PaypalEmail.import_pending' do
      PaypalEmail.should_receive(:import_pending)
      get :check_for_new
    end
    
    it 'should redirect to index path' do
      get :check_for_new
      response.should redirect_to(paypal_emails_path)
    end
  end
  
  describe 'get show' do
    before :each do
      @pe = PaypalEmail.make(:receipt => Receipt.make)
    end
    
    it 'should return success' do
      get :show, :id => @pe.id
      response.status.should == '200 OK'
    end
  end
  
  describe 'put update' do
    it 'should force a refresh of the members financial status' do
      member = Member.make
      member.should_not be_financial
      
      paypal_email = PaypalEmail.make
      put :update, :id => paypal_email.id, :paypal_email => {
        :receipt_attributes => {
          :payment_expires_on => 1.year.from_now.to_date.to_s(:db), 
          :member_id => member.id, 
          :amount => "550.00", 
          :receipt_number => "paypal"
        }}
      paypal_email.reload
      member = paypal_email.member
      member.should be_valid
      member.reload
      member.should be_financial
      member.should == member
    end
  end
  
end
