ActionController::Routing::Routes.draw do |map|
  map.resource :user_session, :except => [:edit, :show, :update]
  map.resources :members, :collection => {:test_worker => :get}
  map.resources :users
  
  map.namespace "admin" do |admin|
    admin.resources :jobs
  end
  
  map.root :controller => 'members', :action => 'index'
end
