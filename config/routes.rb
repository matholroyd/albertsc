ActionController::Routing::Routes.draw do |map|
  map.resource :user_session, :except => [:edit, :show, :update]
  map.resources :members, :collection => {:resigned => :get, :invoice => :post, 
    :toggle_status => :post}
  map.resources :users
  map.resources :paypal_emails, :collection => {:check_for_new => :get}
  map.resources :invoices  
    
  map.root :controller => 'members', :action => 'index'
end
