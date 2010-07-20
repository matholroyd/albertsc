require 'spec_helper'

describe FeedbacksController do
  integrate_views
  
  describe 'GET index' do
    it 'should require login' do
      get :index
      response.status.should == '302 Found'
    end
    
    it 'should be ok if logged in' do
      @user = User.make
      UserSession.create(@user)
      get :index
      response.status.should == '200 OK'
    end
  end
  
  describe 'GET new' do
    it 'should require no login' do
      get :new
      response.status.should == '200 OK'
    end
  end
  
  describe 'POST create' do
    it 'should require no login' do
      post :create, :feedback => {:what_did_you_like_most => 'the boats'}
      response.should redirect_to(thank_you_feedbacks_path)
    end
  end
  
  describe 'GET thank_you' do
    it 'should require no login' do
      get :thank_you
      response.status.should == '200 OK'
    end
  end

end
