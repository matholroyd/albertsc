require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MembersController do

  before :each do
    @user = User.make
    UserSession.create(@user)
  end

  describe 'responding to GET index' do
    it 'should respond with success' do
      get :index
      response.should be_success
    end
  end
  
  describe 'responding to GET new' do
    it 'should respond with success' do
      get :index
      response.should be_success
    end
  end

  describe 'responding to POST create' do
    it 'should respond with success' do
      lambda {
        post :create, :member => {:first_name => 'Bob'}
      }.should change(Member, :count).by(1)
    end
  end



  describe 'responding to POST import' do
    
  end
  

end
