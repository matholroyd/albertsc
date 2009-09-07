class PaypalEmailsController < ApplicationController
  make_resourceful do
    build :all    
  end
  
  def update
    @paypal_email = PaypalEmail.find(params[:id])
    if @paypal_email.update_attributes(params[:paypal_email])
      member = @paypal_email.member
      if member
        member.set_financial
        member.save!
      end
      redirect_to paypal_emails_path
    else
      render 'show'
    end
  end
  
  def show
    @paypal_email = PaypalEmail.find(params[:id])
  end

  def check_for_new
    PaypalEmail.import_pending
    redirect_to paypal_emails_path
  end
    
end
