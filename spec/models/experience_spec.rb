require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Experience do

  before(:each) do
    @experience=Experience.new
    @experience_attributes={
        :technology=>'Java',
        :last_used=>Time.now,
        :duration=>5
    }
    @empty_attributes={

    }
  end

  describe "Should be valid" do
    it "with valid attributes" do
      @experience.attributes=@experience_attributes
      @experience.should be_valid
    end
  end

  describe "Should not be valid" do

    after(:each) do
      @experience.attributes=@invalid_attributes
      @experience.should_not be_valid
    end

    it "without valid attributes" do
      @invalid_attributes=@empty_attributes
    end

    it "without technology" do
      @invalid_attributes=@experience_attributes
      @invalid_attributes.delete :technology
    end

    it "without duration" do
      @invalid_attributes=@experience_attributes
      @invalid_attributes.delete :duration
    end
    it "without duration being numeric" do
      @invalid_attributes=@experience_attributes
      @invalid_attributes[:duration]="ksajd"
    end
  end

  describe "should return max number of experience among profiles" do

    it "should return nil when no profile existed" do
      Experience.max_count_of_experience_among_all_profiles.should == 0
    end

    it "should return max number of experience among profiles" do
      @profile_1 = ModelFactory.create_profile(:employee_id => '98989', :title=>'Developer', :gender=>'Male', :account_no=>'777770', :pan_no=>'777771', :epf_no=>'777772')
      @profile_2 = ModelFactory.create_profile(:employee_id => '98988', :title=>'Developer', :gender=>'Male', :account_no=>'777770', :pan_no=>'777771', :epf_no=>'777772')
      @experiences_1 = ModelFactory.create_experience(:technology => 'Ruby', :last_used => '2011-09-24'.to_datetime, :duration=>'24', :profile=>@profile_1)
      @experiences_2 = ModelFactory.create_experience(:technology => 'Ruby', :last_used => '2009-09-24'.to_datetime, :duration=>'12', :profile=>@profile_1)
      Experience.max_count_of_experience_among_all_profiles.should == 2
    end
  end

end
