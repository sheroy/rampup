require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe College do
  
  before(:each) do
    @college = College.new
  end
  it "should be valid when name is present" do
    @college.name="college"
    @college.should be_valid
  end                 
  it "should not be valid when name is absent" do
    @college.should_not be_valid
    @college.errors[:name].should == ["can't be blank"]
  end
  it "should not be valid when the name is not unique" do
    @college.name="college"
    @college.save
    @college1=College.new
    @college1.name="college"
    @college1.should_not be_valid
    @college1.errors_on(:name).should == ["has already been taken"]
  end
end