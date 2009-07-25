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
  
end
