require 'spec_helper'

describe HomeController do
  integrate_views

  describe "GET index" do
    it "should be successful" do
      get :index
      response.status.should == '200 OK'
    end
  end
end
