require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe Life do
  before(:each) do
    @valid_attributes = {
        :name=>"name",
        :relationship=>"relationship",
        :percentage => 50
    }
    @life_insurance = Life.new
  end
  it "insurance dependent should be less than 100 for an single individual" do
    @life_insurance.attributes = @valid_attributes
    @life_insurance.percentage = 200
    @life_insurance.should_not be_valid

    @life_insurance.errors_on(:percentage).should == ["total percentage should be less than 100% and greater than 1%"]
  end
  it "insurance dependent percentage should be greater than 1 for a individual" do
    @life_insurance.attributes = @valid_attributes
    @life_insurance.percentage = 0
    @life_insurance.should_not be_valid

    @life_insurance.errors_on(:percentage).should == ["total percentage should be less than 100% and greater than 1%"]
  end
  describe "valid" do
    it "should be valid when all the necessary attributes are present" do
      @life_insurance.attributes=@valid_attributes
      @life_insurance.should be_valid
    end
  end
  describe "should not be valid" do
    it "should not be valid when the name is absent" do
      @valid_attributes.delete :name
      @life_insurance.attributes=@valid_attributes
      @life_insurance.should_not be_valid
      @life_insurance.errors_on(:name).should==["can't be blank"]
    end
    it "should not be valid when the percantage is absent" do
      @valid_attributes.delete :percentage
      @life_insurance.attributes=@valid_attributes
      @life_insurance.should_not be_valid
      @life_insurance.errors_on(:percentage).should==["can't be blank", "total percentage should be less than 100% and greater than 1%"]
    end
    it "should not be valid when the name is absent" do
      @valid_attributes.delete :relationship
      @life_insurance.attributes=@valid_attributes
      @life_insurance.should_not be_valid
      @life_insurance.errors_on(:relationship).should==["can't be blank"]
    end
  end

  describe "should return max number of life insurance among profiles" do

    it "should return nil when no profile existed" do
      Life.max_count_of_life_insurance_among_all_profiles.should == 0
    end

    it "should return max number of life insurance among profiles" do
      @profile_1 = ModelFactory.create_profile(:employee_id => '98989', :title=>'Developer', :gender=>'Male', :account_no=>'777770', :pan_no=>'777771', :epf_no=>'777772')
      @profile_2 = ModelFactory.create_profile(:employee_id => '98988', :title=>'Developer', :gender=>'Male', :account_no=>'777770', :pan_no=>'777771', :epf_no=>'777772')
      @life_insurance_1 = ModelFactory.create_life_insurance_beneficiary(:name=>'name life insurance1', :relationship=>'relationship life insurance1', :percentage=>40, :profile=>@profile_1)
      @life_insurance_2 = ModelFactory.create_life_insurance_beneficiary(:name=>'name life insurance2', :relationship=>'relationship life insurance2', :percentage=>50, :profile=>@profile_1)
      Life.max_count_of_life_insurance_among_all_profiles.should == 2
    end
  end

end