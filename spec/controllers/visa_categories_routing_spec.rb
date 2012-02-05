require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VisaCategoriesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "visa_categories", :action => "index").should == "/visa_categories"
    end
  
    it "should map #new" do
      route_for(:controller => "visa_categories", :action => "new").should == "/visa_categories/new"
    end
  
    it "should map #show" do
      route_for(:controller => "visa_categories", :action => "show", :id => "1").should == "/visa_categories/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "visa_categories", :action => "edit", :id => "1").should == "/visa_categories/1/edit"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      {:get => "/visa_categories"}.should route_to(:controller => "visa_categories", :action => "index")
    end
  
    it "should generate params for #new" do
      {:get => "/visa_categories/new"}.should route_to(:controller => "visa_categories", :action => "new")
    end
  
    it "should generate params for #create" do
      {:post => "/visa_categories"}.should route_to(:controller => "visa_categories", :action => "create")
    end
  
    it "should generate params for #show" do
      {:get => "/visa_categories/1"}.should route_to(:controller => "visa_categories", :action => "show", :id => "1")
    end
  
    it "should generate params for #edit" do
      {:get => "/visa_categories/1/edit"}.should route_to(:controller => "visa_categories", :action => "edit", :id => "1")
    end
  
    it "should generate params for #update" do
      { :put => "/visa_categories/1" }.should route_to(:controller => "visa_categories", :action => "update", :id => "1")
    end
  
    it "should generate params for #destroy" do
      { :delete => "/visa_categories/1" }.should route_to(:controller => "visa_categories", :action => "destroy", :id => "1")
    end
  end
end
