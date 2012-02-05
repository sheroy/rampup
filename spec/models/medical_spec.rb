require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe "Medical" do
  before(:each) do
    @medical=Medical.new
    @valid_attributes={
        :name=>'Name',
        :relationship=>'Relation',
        :date_of_birth=>DateTime.parse('22-8-1988')
    }
  end
  it "should be valid with all attributes present" do
    @medical.attributes=@valid_attributes
    @medical.should be_valid
  end
  it "should not be valid if the name is absent" do
    @valid_attributes.delete :name
    @medical.attributes=@valid_attributes
    @medical.should_not be_valid
    @medical.errors_on(:name).should==["can't be blank"]
  end
  it "should not be valid if the name is absent" do
    @valid_attributes.delete :relationship
    @medical.attributes=@valid_attributes
    @medical.should_not be_valid
    @medical.errors_on(:relationship).should==["can't be blank"]
  end
  it "should not be valid if the name is absent" do
    @valid_attributes.delete :date_of_birth
    @medical.attributes=@valid_attributes
    @medical.should_not be_valid
    @medical.errors_on(:date_of_birth).should==["can't be blank"]
  end
  it "should calculate the correct age" do
    @medical.attributes=@valid_attributes
    @medical.age.should==((Date.today-@valid_attributes[:date_of_birth])/365).to_i
  end

  describe "should return max number of medical dependent among profiles" do

    it "should return nil when no profile existed" do
      Medical.max_count_of_medical_dependent_among_all_profiles.should == 0
    end

    it "should return max number of medical dependent among profiles" do
      @profile_1 = ModelFactory.create_profile(:employee_id => '98989', :title=>'Developer', :gender=>'Male', :account_no=>'777770', :pan_no=>'777771', :epf_no=>'777772')
      @profile_2 = ModelFactory.create_profile(:employee_id => '98988', :title=>'Developer', :gender=>'Male', :account_no=>'777770', :pan_no=>'777771', :epf_no=>'777772')
      @medical_dependent = ModelFactory.create_medical_dependent(:name=>'name medical dependent', :relationship=>'relationship medical dependent', :date_of_birth=>'1985-03-05'.to_datetime, :profile=>@profile_1)
      @medical_dependent = ModelFactory.create_medical_dependent(:name=>'name medical dependent', :relationship=>'relationship medical dependent', :date_of_birth=>'1985-03-05'.to_datetime, :profile=>@profile_1)
      Medical.max_count_of_medical_dependent_among_all_profiles.should == 2
    end
  end

end