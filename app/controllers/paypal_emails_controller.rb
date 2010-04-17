class PaypalEmailsController < ApplicationController
  make_resourceful do
    build :all    
  end
  
  def update
    @paypal_email = PaypalEmail.find(params[:id])
    
    if @paypal_email.valid? && !params[:paypal_email][:receipt_attributes][:id].blank?
      receipt = Receipt.find(params[:paypal_email][:receipt_attributes][:id])
      receipt.paypal_email = @paypal_email
      receipt.save!
      
      params[:paypal_email][:receipt_attributes] = {}
    end
    
    if @paypal_email.update_attributes(params[:paypal_email])
      member = @paypal_email.member
      member.update_current_payment_expires_on if member
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
