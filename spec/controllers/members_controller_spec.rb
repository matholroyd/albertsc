require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MembersController do
  integrate_views

  before :each do
    @user = User.make
    UserSession.create(@user)
  end

  describe 'responding to GET index.html' do
    it 'should respond with success' do
      get :index
      response.should be_success
    end
  end

  describe 'responding to GET index.csv' do
    it 'should respond with success' do
      get :index, :format => 'csv'
      response.should be_success
    end
  end
  
  describe 'GET resigned' do
    it 'should respond with success' do
      get :resigned
      response.should be_success
    end
  end
  
  describe 'GET new' do
    it 'should respond with success' do
      get :new 
      response.should be_success
    end
  end

  describe 'POST invoice' do
    it 'should set the session with the member ids' do
      m = Member.make
      post :invoice, :member_ids => [m.id]
      session[:member_ids].should == [m.id]
    end
    
    it 'should redirect to invoices_path' do
      m = Member.make
      post :invoice, :member_ids => [m.id]
      response.should redirect_to(invoices_path(:format => 'pdf'))
    end
    
    it 'should redirect back to members_path if nothing selected' do
      post :invoice
      response.should redirect_to(members_path)
    end
  end

  describe 'responding to POST create' do
    it 'should respond with success' do
      lambda {
        post :create, :member => {:first_name => 'Bob', :membership_type => MembershipType::Senior}
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

  describe 'responding to put update_status' do
    before :each do
      @m = Member.make
    end

    %w{resign activate}.each do |method|
      it "should respond with redirect after #{method}" do
        put :update_status, :id => @m.id, :status => method
        response.should redirect_to(members_path)
      end
    end
    
    it "should change to resigned after updated via resign" do
      put :update_status, :id => @m.id, :status => 'resign'
      @m.reload
      @m.should be_resigned
    end

    it "should change to active after updated via activate" do
      put :update_status, :id => @m.id, :status => 'activate'
      @m.reload
      @m.should be_active
    end
    
  end

  describe 'get recalculate_financial_status_members_path' do
    it 'should call recalculate_financial_status' do
      Member.should_receive(:recalculate_financial_status)
      get :recalculate_financial_status
    end
    
    it 'should redirect to members path' do
      get :recalculate_financial_status
      response.should redirect_to(members_path)
    end
  end
  
  

end
