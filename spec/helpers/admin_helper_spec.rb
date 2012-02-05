require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdminHelper do
  include AdminHelper
  #Delete this example and add some real ones or delete this file
  it "should be included in the object returned by #helper" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(AdminHelper)
  end

  #it "should return true if one of the hash value is greater than zero" do
  #   options = {"Bangalore_Application Developer" => 2, "Chennai_Application Developer" => 4, "Pune_Application Developer" => 5}
  #   valid_table_record?("Application Developer",options).should == true
  #end

  it "should return false when all the hash values are zero" do
     options = {"Bangalore_Application Developer" => 0, "Chennai_Application Developer" => 0, "Pune_Application Developer" => 0}
     valid_table_record?("Application Developer",options).should == false
  end
end