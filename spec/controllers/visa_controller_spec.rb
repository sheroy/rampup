require File.dirname(__FILE__) + '/../spec_helper'
require 'model_factory'
describe VisaController do
  before(:each) do
    @controller.stub!(:check_authentication)
    @visa = Visa.new(:id => 1)
    @passport=Passport.new
    @visa_params = {
      "status" => 'status',
      "appointment_date"=>Time.parse('10/10/2009'),
      "petition_status"=>'petition status',
      "timeline" => 'timeline',
      "issue_date" => Time.parse('10/10/2009'),
      "expiry_date" => Time.parse('10/10/2009'),
      "reason" => 'reason',
      "visa_type" => 'type',
      "country" => 'country',
      "date_of_return" => Time.parse('10/10/2009'),
      "travel_by" => Time.parse('10/10/2009'),
      "category" => 'category',
      "profile_id"=>1
    }
    @profile =  Profile.new(:id => 1)
    @controller.instance_eval {flash.stub!(:sweep) }
  end
  it "should save a new visa and return to the passport and visa information" do
    Profile.should_receive(:find).with('1').and_return(@profile)
    Visa.should_receive(:new).with(@visa_params).and_return(@visa)
    @profile.visas.should_receive("<<").with(@visa).and_return(true)
    post :save, :visa=>@visa_params, :id=>"1"
    response.should redirect_to(:action=>'new', :id=>'1')
    flash[:notice].should =="Visa information was saved successfully"
  end
  it "should render the same page if there are errors in saving the visa " do
    Profile.should_receive(:find).with('1').and_return(@profile)
    Visa.should_receive(:new).with(@visa_params).and_return(@visa)
    @profile.visas.should_receive("<<").with(@visa).and_return(false)
    post :save, :visa=>@visa_params, :id=>"1"
    flash[:error].should=='Some errors prevented visa from saving'
    response.should be
  end
  it "should edit the visa information" do
    Visa.should_receive(:find_or_initialize_by_id).with('1').and_return(@visa)
    Profile.should_receive(:find_or_initialize_by_id).with('1').and_return(@profile)
    Passport.should_receive(:find_or_initialize_by_profile_id).with('1').and_return(@passport)
    get :edit,:id=>'1',:profile_id=>'1'
    response.should be_success
  end
  it "should update the visa information if the attributes are valid" do
    Visa.should_receive(:find_or_initialize_by_id).with('1').and_return(@visa)
    @visa.should_receive("attributes=").with(@visa_params)
    @visa.should_receive(:save).and_return(true)
    post :update,:visa=>@visa_params,:id=>'1',:profile_id=>'1'
    flash[:notice].should=="Visa was updated successfully"
    response.should redirect_to(:action=>'new',:id=>'1')
  end
  it "should update the visa information if the attributes are invalid" do
    Visa.should_receive(:find_or_initialize_by_id).with('1').and_return(@visa)
    @visa.should_receive("attributes=").with(@visa_params)
    @visa.should_receive(:save).and_return(false)
    post :update,:visa=>@visa_params,:id=>'1',:profile_id=>'1'
    flash[:error].should=="Some problems in updating the visa"
    response.should redirect_to(:action=>'new')
  end
  it "should delete the visa information" do
    Visa.should_receive(:find_or_initialize_by_id).with('1').and_return(@visa)
    @visa.should_receive(:destroy).and_return(true)
    get :delete,:id=>'1'
    flash[:notice].should=='Visa information was deleted successfully'
    response.should redirect_to(visa_path(@visa.profile_id))
  end
  describe "dependent visa information" do
    integrate_views
    before(:each) do
      @profile=ModelFactory.create_profile()
      @dependent_passport=ModelFactory.create_dependent_passport(:profile_id=>@profile.id)
      @dependent_visa=DependentVisa.new
    end
    it "should create a new visa information for a dependent" do
      get :add_dependent_visa,:profile_id=>@profile.id,:passport_id=>@dependent_passport.id
      response.should be_success
    end

    it "should save the visa information for the dependent" do
      DependentVisa.should_receive(:new).and_return(@dependent_visa)
      @dependent_visa.should_receive(:update_attributes).and_return(true)
      get :save_dependent_visa,:passport_id=>@dependent_passport.id,:profile_id=>@profile.id
      flash[:notice].should=="Dependent Visa Information was saved successfully"
      response.should redirect_to(visa_path(@profile.id))
    end

    it "should not save the visa information if there is any error in saving" do
      DependentVisa.should_receive(:new).and_return(@dependent_visa)
      @dependent_visa.should_receive(:update_attributes).and_return(false)
      get :save_dependent_visa,:passport_id=>@dependent_passport.id,:profile_id=>@profile.id
      flash[:error].should == "Error while saving dependent information"
      response.should render_template('add_dependent_visa')
    end

    it "should delete the visa information of the dependent" do
      DependentVisa.should_receive(:find).and_return(@dependent_visa)
      @dependent_visa.should_receive(:delete).and_return(true)
      get :delete_dependent_visa,:dependent_visa_id=>1,:passport_id=>@dependent_passport.id,:profile_id=>@profile.id
      flash[:notice].should == 'Dependent Visa was deleted successfully.'
      response.should redirect_to(visa_path(@profile.id))
    end

    it "should display an error message if the visa information cant be deleted" do
      DependentVisa.should_receive(:find).and_return(@dependent_visa)
       @dependent_visa.should_receive(:delete).and_return(false)
      get :delete_dependent_visa,:dependent_visa_id=>1,:passport_id=>@dependent_passport.id,:profile_id=>@profile.id
      flash[:error].should == "Errors while deleting visa"
      response.should redirect_to(visa_path(@profile.id))
    end

    it "should edit the visa information of the dependent" do
      DependentVisa.should_receive(:find).and_return(@dependent_visa)
      get :edit_dependent_visa,:passport_id=>@dependent_passport.id,:dependent_visa_id=>1,:profile_id=>@profile.id
      response.should be_success
      response.should render_template('visa/add_dependent_visa')
    end
  end
end