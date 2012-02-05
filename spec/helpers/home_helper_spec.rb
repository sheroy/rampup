require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "home helper spec" do
  include HomeHelper
  it "should return the appropriate string for the skill set combination" do
    get_skillset_string("Java & .Net").should == "java_net"
    get_skillset_string("Java & Ruby").should == "java_ruby"
    get_skillset_string("Ruby & .Net").should == "ruby_net"
    get_skillset_string("Java, .Net, Ruby").should == "java_net_ruby"
  end

  it "should remove . from the string" do
    get_skills_in_format(".Net").should == "Net"
  end

  it "should give the experience breakdown caption" do
    caption(8).should == "8 to 9 yrs "
  end
end