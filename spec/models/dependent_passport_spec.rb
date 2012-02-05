require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DependentPassport do
  before(:each) do
    @passport = DependentPassport.new
    @valid_attributes = {
      :name=>'dependent_name',
      :number => 'AJ12354',
      :date_of_issue => Time.parse('10/10/2009'),
      :date_of_expiry => Time.parse('10/10/2009'),
      :place_of_issue => 'Chennai',
      :nationality => 'India',
      :profile_id => 1
    }
  end
  it "should be valid when all the attributes are set properly" do
    @passport.attributes = @valid_attributes
    @passport.should be_valid
  end
  it "should be invalid without the passport number" do
    @valid_attributes.delete(:number)
    @passport.attributes = @valid_attributes
    @passport.should_not be_valid
  end
  it "should be invalid without the date of issue" do
    @valid_attributes.delete(:date_of_issue)
    @passport.attributes = @valid_attributes
    @passport.should_not be_valid
  end
  it "should be invalid without the date of expiry" do
    @valid_attributes.delete(:date_of_expiry)
    @passport.attributes = @valid_attributes
    @passport.should_not be_valid
  end
  it "should be invalid without the date of issue" do
    @valid_attributes.delete(:place_of_issue)
    @passport.attributes = @valid_attributes
    @passport.should_not be_valid
  end
  it "should be invalid without the nationality" do
    @valid_attributes.delete(:nationality)
    @passport.attributes = @valid_attributes
    @passport.should_not be_valid
  end
  it "should be invalid without the profile id" do
    @valid_attributes.delete(:profile_id)
    @passport.attributes = @valid_attributes
    @passport.should_not be_valid
  end
  it "should be invalid without name" do
    @valid_attributes.delete(:name)
    @passport.attributes = @valid_attributes
    @passport.should_not be_valid
    
  end
end