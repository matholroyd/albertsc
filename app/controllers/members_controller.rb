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

  def update_status
    current_object.send("#{params[:status]}!")
    redirect_to members_path
  end
  
  def invoice
    session[:member_ids] = params[:member_ids]
    redirect_to invoices_path(:format => 'pdf')
  end
  
end
