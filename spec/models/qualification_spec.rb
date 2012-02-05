require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Qualification do

  before(:each) do
    @qualification=Qualification.new
    @valid_attributes = {
        :graduation_year=>Time.now.year,
        :branch=>'CS',
        :college=>'PSG',
        :profile_id=>10,
        :degree=>'Msc',
        :category=>'Bachelors-Engg'
    }
    @profile=Profile.new
    @profile.id=10
    @profile.location_id="1"


    @empty_attributes={

    }
  end

  describe "should be valid" do
    it "with one qualification" do
      @qualification.attributes = @valid_attributes
      @qualification.should be_valid
    end
    
    it "without branch" do
      @valid_attributes.delete :branch
      @qualification.attributes = @valid_attributes
      @qualification.should be_valid
    end
    
  end

  describe "description" do

    after(:each) do
      @qualification.attributes=@invalid_attributes
    end

    it "without graduation year" do
      @invalid_attributes = @valid_attributes
      @invalid_attributes.delete :graduation_year
    end

    it "with graduation in left boundary" do
      @invalid_attributes=@valid_attributes
      @invalid_attributes[:graduation_year]=200
    end

    it "with graduation year is more than current year" do
      @invalid_attributes = @valid_attributes
      @invalid_attributes[:graduation_year]=5.year.from_now
    end

  end

  describe "should not be valid" do

    after(:each) do
      @qualification.attributes=@invalid_attributes
      @qualification.should_not be_valid
    end

    it "without any qualification" do
      @invalid_attributes = @empty_attributes
    end

    it "without degree" do
      @invalid_attributes = @valid_attributes
      @invalid_attributes.delete :degree

    end

    it "without college" do
      @invalid_attributes = @valid_attributes
      @invalid_attributes.delete :college
    end

  end

  describe "should return max number of qualification among profiles" do

    it "should return nil when no profile existed" do
      Qualification.max_count_of_qualification_among_all_profiles.should == 0
    end

    it "should return max number of qualification among profiles" do
      @profile_1 = ModelFactory.create_profile(attr = {:employee_id => '98989', :title=>'Developer', :gender=>'Male', :account_no=>'777770', :pan_no=>'777771', :epf_no=>'777772'}, qualification_attrs = {:branch=>"cse", :degree=>'BE'})
      @profile_2 = ModelFactory.create_profile(:employee_id => '98988', :title=>'Developer', :gender=>'Male', :account_no=>'777770', :pan_no=>'777771', :epf_no=>'777772')
      @qualification_1 = ModelFactory.create_qualification(:branch=>"cse", :degree=>'BE', :profile=>@profile_1)

      Qualification.max_count_of_qualification_among_all_profiles.should == 2
    end

  end


end