class FeesController < ApplicationController
  skip_before_filter :require_user

  def index
  end
  
  def annual
  end
  
  def winter
  end

  def other
  end

end