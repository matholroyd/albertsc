require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserSessionsController do
  before(:each) do
    @user_session = mock_model(UserSession)
  end

  describe "as a guest user" do
    describe "responding to GET new" do
      it "should expose a new user_session as @user_session" do
        UserSession.should_receive(:new).and_return(@user_session)
        get :new
        assigns[:user_session].should == @user_session
      end
    end

    describe "responding to POST create" do
      it "should create a new user_session" do
        UserSession.should_receive(:new).and_return(@user_session)
        @user_session.should_receive(:save).and_return(true)
        post :create
        assigns[:user_session].should == @user_session
      end
    end

    describe "responding to DELETE destroy" do
      it "should redirect to login" do
        UserSession.should_receive(:find).and_return(nil)
        delete :destroy
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "as a valid user" do
    
    describe "responding to GET new" do
      it "should expose a new user_session as @user_session" do
        UserSession.should_receive(:new).and_return(@user_session)
        get :new
        assigns[:user_session].should == @user_session
      end
      
    end

    describe "responding to POST create" do
      
      it "should create a new user_session" do
        UserSession.should_receive(:new).and_return(@user_session)
        @user_session.should_receive(:save).and_return(true)
        post :create
        assigns[:user_session].should == @user_session
      end
      
      
      it 'should redirect to members' do
        UserSession.should_receive(:new).and_return(@user_session)
        @user_session.should_receive(:save).and_return(true)
        post :create
        response.should redirect_to(members_path)
        
      end
    end

    describe "responding to DELETE destroy" do
      it "should destroy a user_session" do
        UserSession.should_receive(:find).and_return(@user_session)
        @user_session.should_receive(:record).and_return(true)
        @user_session.should_receive(:destroy).and_return(true)
        delete :destroy
        response.should redirect_to(new_user_session_url)
      end
    end
  end
end
