class PaypalEmailsController < ApplicationController
  make_resourceful do
    build :all    
  end
  
  def update
    paypal_email = PaypalEmail.find(params[:id])
    if paypal_email.update_attributes(params[:paypal_email])
      member = paypal_email.member
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
    if @paypal_email.receipt.nil?
      @paypal_email.build_receipt
      @paypal_email.receipt.receipt_number = 'paypal'
      @paypal_email.receipt.amount = @paypal_email.guessed_amount_paid
      @paypal_email.receipt.member_id = @paypal_email.guessed_member_id
    end
  end

  def check_for_new
    PaypalEmail.import_pending
    redirect_to paypal_emails_path
  end
  
end
