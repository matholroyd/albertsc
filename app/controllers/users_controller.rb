class UsersController < ApplicationController
  make_resourceful do
    build :all
    
    response_for :update, :create do |format|
      format.html { redirect_to users_path }
    end
    
    response_for :update_fails do |format|
      format.html { render :action => 'show' }
    end
  end
  
   
end
