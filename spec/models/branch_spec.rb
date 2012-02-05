require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Branch do
  
  before(:each) do
    @branch = Branch.new
  end
  it "should be valid when name is present" do
    @branch.name="college"
    @branch.should be_valid
  end                 
  it "should not be valid when name is absent" do
    @branch.should_not be_valid
    @branch.errors[:name].should == ["can't be blank"]
  end
end