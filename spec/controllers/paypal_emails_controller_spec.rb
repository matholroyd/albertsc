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
  
end
