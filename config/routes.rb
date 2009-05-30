ActionController::Routing::Routes.draw do |map|
  map.resource :user_session, :except => [:edit, :show, :update]
  map.resources :members, :collection => {:import => :get, :import_file => :post}, 
    :member => {:update_status => :put}
  map.resources :users
    
  map.root :controller => 'members', :action => 'index'
end
