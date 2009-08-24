ActionController::Routing::Routes.draw do |map|
  map.resource :user_session, :except => [:edit, :show, :update]
  map.resources :members, :member => {:update_status => :put}, :collection => {:resigned => :get}
  map.resources :users
  map.resources :paypal_emails
    
  map.root :controller => 'members', :action => 'index'
end
