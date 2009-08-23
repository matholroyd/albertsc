class PaypalEmailsController < ApplicationController
  make_resourceful do
    build :all    

    response_for :update do |format|
      format.html { redirect_to(paypal_emails_path) }
    end
    
    response_for :update_fails do |format|
      format.html {render :action => 'show'}
    end
  end
  
  def show
    @paypal_email = PaypalEmail.find(params[:id])
    @paypal_email.build_receipt
    @paypal_email.receipt.receipt_number = 'paypal'
    @paypal_email.receipt.amount = @paypal_email.guessed_amount_paid
    @paypal_email.receipt.member_id = @paypal_email.guessed_member_id
  end
  
end
