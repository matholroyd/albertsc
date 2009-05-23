require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MembersController do
  integrate_views

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
  
  describe 'responding do PUT update' do
    before :each do
      @m = Member.make
    end
    
    describe 'with valid params' do
    
      it 'should respond with success' do
        put :update, :id => @m.id
        response.should redirect_to(member_path(@m))
      end
    end

    describe 'with invalid params' do
      it 'should respond with success' do
        put :update, :id => @m.id, :member => {:first_name => '', :last_name => '', :preferred_name => ''}
        response.should render_template('members/show.html.haml')
      end
      
    end
    
  end

  describe 'responding to POST import' do
    
  end
  

end
