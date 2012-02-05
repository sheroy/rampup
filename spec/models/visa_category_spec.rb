require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VisaCategory do
  before(:each) do
    @valid_attributes = {
      :name=>'type'
    }
  end

  it "should create a new instance given valid attributes" do
    VisaCategory.create!(@valid_attributes)
  end
end
