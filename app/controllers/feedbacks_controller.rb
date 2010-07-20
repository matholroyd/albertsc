class FeedbacksController < ApplicationController
  skip_before_filter :require_user, :only => [:new, :create, :thank_you]

  make_resourceful do
    build :all
    
    response_for :create do |format|
      format.html { redirect_to(thank_you_feedbacks_path) }
    end
    
  end

end
