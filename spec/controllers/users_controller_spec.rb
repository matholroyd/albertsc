require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do

  before :each do
    @user = User.make
    UserSession.create(@user)
  end

  describe 'respoonding to GET #index' do
    it 'should respond ok' do
      get :index
      response.should be_success
    end
    
  end

  describe 'responding to GET #show' do
    
    it 'should respond ok' do
      get :show, :id => @user.id
      response.should be_success
    end
    
  end
  
  describe 'responding to PUT #update' do

    describe 'valid params' do
      it 'should redirect to index' do
        put :update, :id => @user.id
        response.should redirect_to(users_path)
      end
    end

    describe 'invalid params' do
      it 'should render to show' do
        put :update, :id => @user.id, :user => {:email => ''}
        response.should render_template('users/show.html.haml')
      end
    end
    
  end
  
  describe 'responding to GET #new' do
    it 'should respond ok' do
      get :new
      response.should be_success
    end
    
  end

  
  describe 'responding to POST #create' do

    describe 'valid params' do
      it 'should redirect to index' do
        User.should_receive(:new).and_return(@user)
        post :create
        response.should redirect_to(users_path)
      end
    end

    describe 'invalid params' do
      it 'should render to new' do
        post :create
        response.should render_template('users/new.html.haml')
      end
    end
    
  end
end
