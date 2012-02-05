require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TemplateGeneratorsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "template_generators", :action => "index").should == "/template_generators"
    end
  
    it "should map #new" do
      route_for(:controller => "template_generators", :action => "new").should == "/template_generators/new"
    end
  
    it "should map #show" do
      route_for(:controller => "template_generators", :action => "show", :id => "1").should == "/template_generators/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "template_generators", :action => "edit", :id => "1").should == "/template_generators/1/edit"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/template_generators").should == {:controller => "template_generators", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/template_generators/new").should == {:controller => "template_generators", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/template_generators").should == {:controller => "template_generators", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/template_generators/1").should == {:controller => "template_generators", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/template_generators/1/edit").should == {:controller => "template_generators", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      { :put => "/template_generators/1" }.should route_to(:controller => "template_generators", :action => "update", :id => "1")
    end
  
    it "should generate params for #destroy" do
      { :delete => "/template_generators/1" }.should route_to(:controller => "template_generators", :action => "destroy", :id => "1")
    end
  end
end
