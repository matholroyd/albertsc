ActionController::Routing::Routes.draw do |map|
  map.resource :user_session, :except => [:edit, :show, :update]
  map.resources :members, :collection => {:import => :get, :import_file => :post}
  map.resources :users
    
  map.root :controller => 'members', :action => 'index'
end
