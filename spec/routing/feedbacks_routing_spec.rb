require 'spec_helper'

describe FeedbacksController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/feedbacks" }.should route_to(:controller => "feedbacks", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/feedbacks/new" }.should route_to(:controller => "feedbacks", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/feedbacks/1" }.should route_to(:controller => "feedbacks", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/feedbacks/1/edit" }.should route_to(:controller => "feedbacks", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/feedbacks" }.should route_to(:controller => "feedbacks", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/feedbacks/1" }.should route_to(:controller => "feedbacks", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/feedbacks/1" }.should route_to(:controller => "feedbacks", :action => "destroy", :id => "1") 
    end
  end
end
