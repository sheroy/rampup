require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Signature do
  before(:each) do
    @valid_attributes = {
      :name => 'my_name',
      :signature => 'my_signature'
    }
  end

  it "should create a new instance given valid attribute" do
    Signature.create!(@valid_attributes)
  end
end
