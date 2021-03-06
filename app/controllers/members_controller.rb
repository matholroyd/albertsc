class MembersController < ApplicationController
  make_resourceful do
    build :all
    
    response_for :update_fails do |format|
      format.html { render :action => 'show' }
    end
    
    response_for :index do |format| 
      format.html { @state = 'active'; render 'list'}
      format.csv
    end
    
  end

  def resigned
    @state = 'resigned'
    render 'list'
  end
  
  def toggle_status
    params[:member_ids].each do |id|
      Member.find(id).toggle_status!
    end
    
    redirect_to members_path
  end
  
  def invoice
    session[:member_ids] = params[:member_ids]
    
    if session[:member_ids] && session[:member_ids].length > 0
      redirect_to invoices_path(:format => 'pdf')
    else
      flash[:error] = 'No members selected!'
      redirect_to members_path
    end
  end
  
end
