ActionController::Routing::Routes.draw do |map|
  map.resource :user_session, :except => [:edit, :show, :update]
  map.resources :members, :collection => {:resigned => :get, :invoice => :post, :recalculate_financial_status => :get}, 
    :member => {:update_status => :put}
  map.resources :users
  map.resources :paypal_emails, :collection => {:check_for_new => :get}
  map.resources :invoices  
    
  map.root :controller => 'members', :action => 'index'
end
