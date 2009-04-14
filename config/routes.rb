ActionController::Routing::Routes.draw do |map|
  map.resource :user_sessions, :except => [:edit, :show, :update]
end
