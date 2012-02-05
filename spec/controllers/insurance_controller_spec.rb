require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe InsuranceController do
  before(:each) do
    @profile=Profile.new(:id => 1)
    @medical=Medical.new
    @life_insurance = Life.new(:percentage=>50)
    @dependent_params={
      "name"=>"name",
      "relationship"=>"relation",
      "date_of_birth"=>Time.parse('10/10/2009'),
      "profile_id" => 1
    }
  end
  describe "Life Insurance" do
    
    it "should delete the medical dependent information" do
      Life.should_receive(:find).with('1').and_return(@life_insurance)
      @life_insurance.should_receive(:destroy).and_return(true)
      get :delete_life_insurance,:id=>'1', :life_insurance_id=>'1'
      flash[:notice].should=='Life Insurance Information was saved successfully.'
      response.should redirect_to(:action=>'new_life_insurance',:id=>'1')
    end
    
    it "should load the insurance form for the profile" do
      Profile.should_receive(:find).with('1').and_return(@profile)
      get :new_life_insurance, :id=>1
      response.should be_success
    end
    it "should delete the life insurance information" do
      Life.should_receive(:find).with('1').and_return(@life_insurance)
      @life_insurance.should_receive(:destroy).and_return(true)
      get :delete_life_insurance, :id=>'1',:life_insurance_id=>'1'
      flash[:notice].should == "Life Insurance Information was saved successfully."
    end

    it "should save the life insurance dependents to the right profile" do
      @post_params_for_life_insurance = {
        :name=>'name',
        :date_of_birth=>DateTime.parse('10/10/2009'),
        :relationship=>'Father',
        :percentage=>'30'
      }
      Profile.should_receive(:find).with('1').and_return(@profile)
      post :save_life_insurance, :id=>1, :life=>@post_params_for_life_insurance
      response.should redirect_to(:action=>'new_life_insurance', :id=>1)
    end
    it "should edit the life insurance details for the right profile and right insurance dependent" do
      Profile.should_receive(:find).with('1').and_return(@profile)
      Life.should_receive(:find).with('1').and_return(@life_insurance)
      get :edit_life_insurance , :id=>1, :life_insurance_id=>'1'
    end
    it "should update the life insurance details for the right insurance" do
       @post_params_for_life_insurance = {
          "name"=>'name',
          "date_of_birth"=>DateTime.parse('10/10/2009'),
          "relationship"=>'Father',
          "percentage"=>'30'
        }
      Life.should_receive(:find).with('1').and_return(@life_insurance)
      Profile.should_receive(:find).with('1').and_return(@profile)
      @life_insurance.should_receive("attributes=").with(@post_params_for_life_insurance)
      post :update_life_insurance,:life=>@post_params_for_life_insurance,:id=>1, :life_insurance_id=>'1'
      response.should redirect_to(:action=>'new_life_insurance',:id=>'1')
    end
  end

  describe "Medical Insurance" do
    it "should load the insurance form for profile" do
      Profile.should_receive(:find).with('1').and_return(@profile)
      Medical.should_receive(:new).and_return(@medical)
      get :new_medical_insurance,:id=>'1'
      response.should be_success
    end

    it "should save the information for the profile" do
      Profile.should_receive(:find).with('1').and_return(@profile)
      Medical.should_receive(:new).with(@dependent_params).and_return(@medical)
      @profile.medicals.should_receive('<<').and_return(true)
      post :save_medical_insurance,:medical=>@dependent_params,:id=>'1'
      response.should redirect_to(:action=>'new_medical_insurance',:id=>'1')
      flash[:notice].should=="Dependents information was saved successfully"
    end

    it "should render the same page if the validation fails" do
      Profile.should_receive(:find).with('1').and_return(@profile)
      Medical.should_receive(:new).with(@dependent_params).and_return(@medical)
      @profile.medicals.should_receive('<<').and_return(false)
      post :save_medical_insurance,:medical=>@dependent_params,:id=>'1'
      response.should redirect_to(:action=>'new_medical_insurance',:id=>'1') 
      flash[:error].should=='Errors while saving the dependents information'
    end

    it "should edit the medical information" do
      Profile.should_receive(:find).with('1').and_return(@profile)
      Medical.should_receive(:find_or_initialize_by_id).with('1').and_return(@medical)
      get :edit_medical_insurance,:profile_id=>'1',:id=>'1'
      response.should be
    end

    it "should update the medical information" do
      Medical.should_receive(:find_or_initialize_by_id).with('1').and_return(@medical)
      @medical.should_receive("attributes=").with(@dependent_params)
      @medical.should_receive(:save).and_return(true)
      post :update_medical_insurance,:medical=>@dependent_params,:profile_id=>'1',:id=>'1'
      flash[:notice].should=="medical insurance information was updated successfully"
      response.should redirect_to(:action=>'new_medical_insurance',:id=>'1')
    end

    it "should render the same page if there are errors in updating the information" do
      Medical.should_receive(:find_or_initialize_by_id).with('1').and_return(@medical)
      @medical.should_receive("attributes=").with(@dependent_params)
      @medical.should_receive(:save).and_return(false)
      post :update_medical_insurance,:medical=>@dependent_params,:profile_id=>'1',:id=>'1'
      flash[:error].should=="errors while updating the medical insurance information"
      response.should redirect_to(:action=>'new_medical_insurance',:id=>'1')
    end

    it "should delete the medical dependent information" do
      Medical.should_receive(:find_or_initialize_by_id).with('1').and_return(@medical)
      @medical.should_receive(:destroy).and_return(true)
      get :delete_medical_insurance,:profile_id=>'1',:id=>'1'
      flash[:notice].should=='Medical dependents information was deleted successfully'
      response.should redirect_to(:action=>'new_medical_insurance',:id=>'1')
    end

    it "should dispay the life and medical insurance information" do
      @controller.stub!(:show_insurance)
      get :show_insurance
      
      response.should render_template('insurance/show_insurance')
    end
  end
end