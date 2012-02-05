require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PassportController do

  describe "admin" do
    before(:each) do
      @controller.stub!(:check_authentication)
      @controller.instance_eval {flash.stub!(:sweep) }
      @controller.set_current_user User.new({:role => 'admin'})
      @dependent_passports = [mock(DependentPassport, :profile_id => 1)]
      @passport = mock(Passport, :profile_id => 1)
      @profile = mock(Profile, {:id => 1, :passport => nil, :dependent_passports => @dependent_passports})
      @post_params = {
        "profile_id"=>'1',
        "number"=>'12345',
        "date_of_issue"=>Time.parse('10/10/2009'),
        "date_of_expiry" => Time.parse('10/10/2009'),
        "nationality"=>'Indian'
      }
    end

    it "should add new passport information for employee" do
      Profile.should_receive(:find).with("1").and_return(@profile)
      Passport.should_receive(:find_or_initialize_by_profile_id).with(1).and_return(@passport)
      get :new, :profile_id=>"1"
      response.should be_success
    end

    it "should save the passport information and redirect to the same page" do
      Profile.should_receive(:find).with('1').and_return(@profile)
      Passport.should_receive(:find_or_initialize_by_profile_id).with(1).and_return(@passport)
      @passport.should_receive(:update_attributes).with(@post_params).and_return(true)
      post :save, :passport=>@post_params, :profile_id=>'1'
      flash[:notice].should == "Passport Information was successfully saved."
      response.should redirect_to(visa_path("1"))
    end

    it "should edit the passport information of the employee" do
      Profile.should_receive(:find).with('1').and_return(@profile)
      Passport.should_receive(:find_or_initialize_by_profile_id).with(1).and_return(@passport)
      get :edit ,:profile_id=>'1'
      response.should be_success
    end

    it "should find the profile and its passport based on the id" do
      Profile.should_receive(:find).with('1').and_return(@profile)
      Passport.should_receive(:find_by_profile_id).with(1).and_return(@passport)
      get :show,:profile_id=>'1'
      response.should be_success
    end
  end

  describe "employee" do
    before do
      @controller.set_current_user(User.employeeUser 'ducky')
    end

    before :each do
      @passport = mock(Passport, :profile_id => 1)
      @profile = mock(Profile, {:id => 1, :passport => @passport})
    end

    it "should allow employee to access his own passport information" do
      dependent_passports = [mock(DependentPassport, :profile_id => 1)]
      passport = mock(Passport, :profile_id => 1)
      profile = mock(Profile, {:id => 1, :passport => passport, :dependent_passports => dependent_passports})
      Profile.should_receive(:find_by_email_id).with('ducky').and_return(profile)
      Passport.should_receive(:find_by_profile_id).with(1).and_return(passport)

      get :show
      response.should be_success
      assigns(:passport).should be == profile.passport
      assigns(:dependent_passports).should be == profile.dependent_passports
    end

    it "should go to edit the passport details" do
      Profile.should_receive(:find_by_email_id).with('ducky').and_return(@profile)
      get :edit
      response.should be_success
    end

    it "should save the passport details" do
      Profile.should_receive(:find_by_email_id).with('ducky').and_return(@profile)
      post :save, :profile_id => @profile.id, :passport => {:number => "PN12345", :date_of_issue => "2011-10-31", :date_of_expiry => "2021-10-31", :place_of_issue => "India", :nationality => "India"}

      response.should redirect_to(employee_passport_path)
      flash[:notice].should == "Passport Information was successfully saved."
    end
  end

  describe "all users" do
    it "should give warning when the nationality and date of expiry are missing" do
      @controller.set_current_user(User.employeeUser 'ducky')

      profile = ModelFactory.create_profile :email_id => 'ducky'
      passport = ModelFactory.create_passport :profile => profile
      profile.passport = passport

      @controller.should_receive(:render).with(:action=>:edit)
      post :save, :profile_id => profile.id, :passport => {:number => "12345678", :date_of_issue => "2011-10-31", :date_of_expiry => "", :place_of_issue => "India", :nationality => ""}
      missing_fields = "Date of expiry, Nationality"
      response.should be_success
      passport.number.should_not eql("12345678")
      expected_error = 'Following fields are not specified - ' + missing_fields
      flash.now_cache[:error].should == expected_error
    end

  end
end