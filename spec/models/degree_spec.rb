require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe Degree do
   before(:each) do
    @degree = Degree.new
  end
  it "should be valid when name is present" do
    @degree.name="degree"
    @degree.category="category"
    @degree.should be_valid
  end
  it "should not be valid when name is absent" do
    @degree.should_not be_valid
    @degree.errors[:name].should == ["can't be blank"]
  end
end