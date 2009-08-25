ActionController::Routing::Routes.draw do |map|
  map.resource :user_session, :except => [:edit, :show, :update]
  map.resources :members, :collection => {:resigned => :get, :invoice => :post}, 
    :member => {:update_status => :put}
  map.resources :users
  map.resources :paypal_emails
  map.resources :invoices  
    
  map.root :controller => 'members', :action => 'index'
end
