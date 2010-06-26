require 'spec_helper'

describe FeesController do
  integrate_views

  describe "GET index" do
    it "should be successful" do
      get :index
      response.status.should == '200 OK'
    end
  end
  
  describe "GET annual" do
    it "should be successful" do
      get :annual
      response.status.should == '200 OK'
    end
  end

  describe "GET winter" do
    it "should be successful" do
      get :winter
      response.status.should == '200 OK'
    end
  end

  describe "GET other" do
    it "should be successful" do
      get :other
      response.status.should == '200 OK'
    end
  end
end
