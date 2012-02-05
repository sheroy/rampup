require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdminPassportController do

  before(:each) do
    @controller.stub!(:check_authentication)
    @controller.instance_eval {flash.stub!(:sweep) }
    @profile = Profile.new(:common_name=>'rampup')
    RELATION_FOR_PASSPORT=["SON"] unless defined?(RELATION_FOR_PASSPORT)
    @passport = Passport.new(:id=>1)
    @visa = Visa.new(:id=>1)
    @post_params = {
      "profile_id"=>1,
      "number"=>'12345',
      "date_of_issue"=>Time.parse('10/10/2009'),
      "date_of_expiry" => Time.parse('10/10/2009'),
      "nationality"=>'Indian'
    }
  end

  it "should add new passport information for employee" do
    Profile.should_receive(:find).with("1").and_return(@profile)
    Passport.should_receive(:find_or_initialize_by_profile_id).with('1').and_return(@passport)
    get :new, :id=>"1"
    response.should be_success
  end

  it "should save the passport information and redirect to the same page" do
    Profile.should_receive(:find).with('1').and_return(@profile)
    Passport.should_receive(:find_or_initialize_by_profile_id).with('1').and_return(@passport)
    @passport.should_receive(:update_attributes).with(@post_params).and_return(true)
    post :save, :passport=>@post_params, :profile_id=>'1'
    flash[:notice].should == "Passport Information was successfully saved."
    response.should redirect_to(:action=>:new, :id=>@profile.id)
  end

  it "should not save the passport information if the necessary details are not found" do
    Profile.should_receive(:find).with('1').and_return(@profile)
    Passport.should_receive(:find_or_initialize_by_profile_id).with('1').and_return(@passport)
    @passport.should_receive(:update_attributes).and_return(false)
    @controller.should_receive(:render).with(:action=>:edit, :id=>@profile.id)
    post :save, :passport=>@post_params, :profile_id=>'1'
    flash[:error].should == "Errors while saving Passport information"
  end

  it "should edit the passport information of the employee" do
    Profile.should_receive(:find).with('1').and_return(@profile)
    Passport.should_receive(:find_or_initialize_by_profile_id).with('1').and_return(@passport)
     get :edit ,:id=>'1'
     response.should be_success
  end

  describe "Dependent's passport" do
    integrate_views
    it "should create a new dependent passport" do
      pending "problem with integrating views in controller spec"
       profile=ModelFactory.create_profile
      get :add_new_dependent, :id=>profile.id
      response.should be
      response.should have_tag('h3', "Add Dependent's Passport information for rampup")
    end

    it "should save the dependent's passport information" do
      profile=ModelFactory.create_profile
      get :save_dependent,:profile_id=>profile.id, :dependent_passport=>{:name=>'dependent name', :relationship=>'relationship', :number=>'12345', :date_of_issue=>Time.zone.today, :date_of_expiry=>Time.zone.today,:place_of_issue=>'place',:nationality=>'India'}
      DependentPassport.count.should==1
      flash[:notice].should == "Dependent Passport Information was successfully saved."
      response.should redirect_to(:action=>:new,:id=>profile.id)
    end

    it "should not save the dependent's passport information" do
      profile=ModelFactory.create_profile
      dependent=DependentPassport.new
      Profile.should_receive(:find).and_return(profile)
      DependentPassport.should_receive(:new).and_return(dependent)
      dependent.should_receive(:update_attributes).and_return(false)
      get :save_dependent,:profile_id=>profile.id, :dependent_passport=>{:name=>'dependent name', :relationship=>'relationship', :number=>'12345', :date_of_issue=>Time.zone.today, :date_of_expiry=>Time.zone.today,:place_of_issue=>'place',:nationality=>'India'}
      flash[:error].should == "Errors while saving Dependent's Passport information"
      response.should render_template('add_new_dependent')
    end

    it "delete the dependent passport" do
      dependent_passport = DependentPassport.new
      DependentPassport.should_receive(:find).and_return(dependent_passport)
      dependent_passport.should_receive(:delete).and_return(true)
      get :delete_dependent , :id=>'id', :dependent_passport_id=>'id'
      flash[:notice].should == "Dependent Passport was deleted successfully."
      response.should redirect_to(:action=>:new , :id=>'id')
    end

    it "should not delete the dependent information if there is some error in deleting" do
      dependent_passport = DependentPassport.new
      DependentPassport.should_receive(:find).and_return(dependent_passport)
      dependent_passport.should_receive(:delete).and_return(false)
      get :delete_dependent , :id=>'id', :dependent_passport_id=>'id'
      flash[:error].should == "Errors while deleting passport"
      response.should redirect_to(:action=>:new , :id=>'id')
    end
  end
end
