require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Country do
  before(:each) do
    @country=Country.new
    @valid_attributes={
      :name => 'India'
    }
  end
  
it "should be valid with valid attributes" do
  @country.attributes = @valid_attributes
  @country.should be
end

it "should be invalid with invalid attributes" do
  @valid_attributes.delete(:name)
  @country.attributes = @valid_attributes
  @country.should_not be_valid
end

  it "should be invalid if the name is not unique" do
    @country.attributes=@valid_attributes
    @country.save
    @country1=Country.new
    @country1.name='India'
    @country1.should_not be_valid
    @country1.errors_on(:name).should==["has already been taken"]
  end

end
