require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../model_factory')

describe ProfileController do
  before(:each) do
    @profile = Profile.new
    @projects = mock("Projects")
    @resource = mock("Resource", :LocationID=>'id', :ResourceID =>'resource ID')
    @assignments = mock("assignments")
    @profile.qualifications << Qualification.new
    @controller.params[:profile]=mock("profile params")
    @controller.instance_eval { flash.stub!(:sweep) }
    @controller.set_current_user(User.new(:username=>"admin", :password=>"pass", :role=>"admin"))
  end

  describe "Passport Information" do
    it "should get the passport details and show the passport details" do
      @passport = Passport.new
      Profile.stub!(:find).with("1").and_return(@profile)
      Passport.should_receive(:new).and_return(@passport)
      get :passport_information, :id => 1
      response.should be_success
    end
    it "should display the passport details if its already available" do
      @passport = Passport.new
      @profile.passport = @passport
      Profile.stub!(:find).with("1").and_return(@profile)
      get :passport_information, :id => 1
      response.should be_success
    end
  end

  describe "view" do
    render_views
    it "should render the profile form" do
      @controller.stub!(:render).with(:template => 'profile/profile_form')
      Title.stub!(:all)
      get :new
      response.should be_success
    end
  end

  describe "show" do
    render_views

    it "should raise an exception if the profile does not exist" do
      lambda { get :show, :id => 123 }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "edit" do
    it "should edit a profile if it exists" do
      Profile.stub!(:find).and_return(@profile)
      get :edit, :id=>'22'
      response.should be_success
    end
  end
  describe "new" do
    it "should create a new profile" do
      # pending "unixODBC problem"
      Profile.stub!(:new).and_return(@profile)
      get :new
      response.should be_success
    end
  end


  describe "edit_last_day" do
    it "should load the profile object to be edited" do
      Profile.should_receive(:find).and_return(@profile)
      get :edit_last_day
      response.should be_success
    end
  end


  describe "save_last_day" do
    before(:each) do
      Profile.should_receive(:find_by_id).and_return(@profile)
    end
    it "should get date of exit and save the object" do
      @profile.should_receive(:save).and_return(true)
      get :save_last_day, :id=>@profile.id
      response.should redirect_to(show_profile_path(@controller.params[:id]))
      flash[:notice].should == "Last date has been saved successfully"
    end

    it "should not save if invalid resignation date is selected" do
      @profile.date_of_joining = DateTime.now
      post :save_last_day, :id => @profile.id, :profile => {:last_day => DateTime.now - 20}
      flash[:error].should == "Error in date of exit"
    end
  end

  describe "update" do
    it "should not save a profile temporarily without validation when employee id is invalid" do
      profile = {"employee_id" => "123"}
      years=4
      months=3
      @profile=Profile.new(profile)
      @profile.save(:validate => false)
      Profile.should_receive(:find_by_id).and_return(@profile)
      @controller.should_receive(:render).with(:template=>'profile/edit_profile_form')
      render_views
      post :update, :profile=>profile, :id =>@profile.id, :years=>years, :months=>months
      @profile.years_of_experience.should==51
      flash[:error].should=="Employee ID should be a unique 5 digit number"
    end

    it "bug fix: should change the profile to incomplete when already marked as complete" do
      @profile = Profile.new(:employee_id=>'12345', :completed=>true)
      @profile.save(:validate => false)
      post :update, :profile=> {:employee_id=>'12345'}, :id=>@profile.id, :years =>4, :months=> 3
      profile = Profile.find(@profile.id)
      profile.completed.should == false
    end

    it "should display the edit page when profile is valid" do
      profile = {"employee_id" => "12345"}
      @profile=Profile.new(profile)
      @profile.save(:validate => false)
      Profile.should_receive(:find_by_id).and_return(@profile)
      post :update, :profile=>profile, :id =>@profile.id
      response.should redirect_to(:controller=>'qualification', :action=>'add', :id=>@profile.id)
    end

    it "should save profile as draft on edit profile page" do
      profile = {"employee_id" => "12345"}
      @profile=Profile.new(profile)
      @profile.save(:validate => false)
      Profile.should_receive(:find_by_id).and_return(@profile)
      post :update, :profile=>profile, :id =>@profile.id, :commit=>"Save As Draft"
      response.should render_template("profile/edit_profile_form")
    end
  end

  describe "create" do
    it "should create a profile temporarily without validation" do
      profile_params = {"employee_id" => "78901"}
      @profile = Profile.new("employee_id"=>"78901")
      @profile.save(:validate => false)
      Profile.stub!(:new).and_return(@profile)
      @profile.should_receive(:attributes=).with({"years_of_experience"=>"62", "id"=>"1", "employee_id"=>"78901"})
      post :create, :profile => profile_params, :id=>'1', :years => "5", :months=>"2"
      response.should redirect_to(:controller=>'qualification', :action=>'add', :id=>@profile.id)
    end

    it "should not create a profile temporarily without validations on employee id" do
      profile_params = {"employee_id" => "145"}
      @profile = Profile.new(:employee_id=>"145", :id=>1)
      @controller.should_receive(:render).with(:template=>'profile/profile_form')
      post :create, :profile => profile_params, :id => "1"
      flash[:error].should == "Employee ID should be a unique 5 digit number"
    end

    it "should save profile as draft on new profile page" do
      profile_params = {"employee_id" => "78901"}
      @profile = Profile.new("employee_id"=>"78901")
      @profile.save(:validate => false)
      Profile.stub!(:new).and_return(@profile)
      @profile.should_receive(:attributes=).with({"years_of_experience"=>"62", "id"=>"1", "employee_id"=>"78901"})
      post :create, :profile => profile_params, :id=>'1', :years => "5", :months=>"2", :commit=>"Save As Draft"
      response.should render_template("profile/profile_form")
    end

  end

  describe "complete" do
    before(:each) do
      Profile.should_receive(:find_by_id).and_return(@profile)
    end
    it "should mark the profile as final" do
      @profile.should_receive(:save).and_return(true)
      @profile.should_receive(:mark_as_complete)
      get :complete, :id=>@profile.id
      response.should redirect_to(show_profile_path(@profile.id))
      flash[:notice].should == "Profile was successfully saved."
    end
    it "should display an error if the profile cannot be saved due to validation errors" do
      @profile.should_receive(:save).and_return(false)
      get :complete, :id=>@profile.id
      response.should redirect_to(edit_profile_path(@profile.id))
      flash[:error].should == "Following errors prohibited the profile from being saved <br />"
    end
  end
  describe "financial_details" do
    describe "form" do
      before(:each) do
        @financial_post_params = {
            "account_no" => 'Account No',
            "pan_no" => 'PAN No',
            "epf_no" => 'epf no'
        }
      end
      it "should be displayed" do
        Profile.stub!(:find).with('1').and_return(@profile)
        get :financial_details, :id=>'1'
      end
      it "should render the same page if there are some errors while saving the profile" do
        Profile.stub!(:find).with('1').and_return(@profile)
        @profile.should_receive("attributes=").with(@financial_post_params)
        @profile.should_receive(:save).and_return(false)
        @controller.should_receive(:render).with(:financial_details)
        post :save_financial_details, :id=>'1', :profile => @financial_post_params
        flash[:error].should == "Some errors prohibited the Financial information from being saved"
      end
      it "should save the financial details successfully" do
        @profile.id=1
        Profile.stub!(:find).with('1').and_return(@profile)
        @profile.should_receive("attributes=").with(@financial_post_params)
        @profile.should_receive(:save).and_return(true)
        post :save_financial_details, :id=>'1', :profile => @financial_post_params
        response.should redirect_to(show_profile_path("1"))
        flash[:notice].should == "Verify all the details and <a href=\"/profile/complete/#{@profile.id}\">Click here</a> to save as final"
      end

      it "should save financial details on Financial Information page" do
        @profile=ModelFactory.create_profile
        post :save_financial_details, :id=>@profile.id, :profile => @financial_post_params,:commit=>"Save As Draft"
        flash[:notice].should == "Profile Temporarily Saved"
        @actual = Profile.find_by_id(@profile.id)
        @actual.attributes["account_no"].should == 'Account No'
        @actual.attributes["pan_no"].should == 'PAN No'
        @actual.attributes["epf_no"].should == 'epf no'
      end

    end
  end
end
