class PaypalEmailsController < ApplicationController
  make_resourceful do
    build :all    
    
    response_for :update do |format|
      format.html { redirect_to(paypal_emails_path) }
    end
  end
  
end
