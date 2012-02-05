require 'spec_helper'

describe EmployeeController do
  before(:each) do
    user = mock(User)
    controller.stub!(:current_user).and_return(user)
    user.stub!(:username).and_return(:jesus)
    @attached_documents = mock("double of attached documents")
    @profile = double :attached_documents => @attached_documents
  end

  it "should show employee details" do
    Profile.should_receive(:find_by_email_id).with(:jesus).and_return(:profile)
    get :index
    assigns(:user_profile).should be == :profile
  end

  it "should show the documents" do
    Profile.should_receive(:find_by_email_id).with(:jesus).and_return(@profile)
    get :documents
  end

  it "should assigns the list of documents" do
    Profile.should_receive(:find_by_email_id).with(:jesus).and_return(@profile)
    get :documents
    assigns(:attached_documents).should == @attached_documents
  end

  describe "edit" do
    it "should edit personal details if it exists" do
      Profile.should_receive(:find_by_email_id).with(:jesus).and_return(:profile)
      get :edit
      assigns(:user_profile).should be :profile
      response.should be_success
      response.should render_template 'employee/edit_personal_details_form'
    end
  end

  describe "update" do
    it "should update the personal details" do
      profile = ModelFactory.create_profile
      Profile.should_receive(:find_by_email_id).with(:jesus).and_return(profile)
      details = {'emergency_contact_number' => '4321', 'title'=>'Developer',
                 'marital_status'=>'single', 'emergency_contact_person'=>'friend',
                 'personal_email_id'=>'friend@gmail.com','permanent_phone_number'=>"1233445",
                 'temporary_phone_number'=>"12334354"}
      profile.attributes= details
      post :update, :profile => details
      Profile.find_by_id(profile.id).attributes.should include details
              response.should redirect_to :action => :index
      flash[:notice].should == "Your changes have been saved"
    end

    it "should not update the personal details without correct format for personal email" do
      profile = ModelFactory.create_profile(:personal_email_id => 'nana@gmail.com')
      Profile.should_receive(:find_by_email_id).with(:jesus).and_return(profile)
      post :update, :profile => {:personal_email_id => 'nanis.gmail.com'}
      assigns(:user_profile).should be profile
      Profile.find_by_id(profile.id).personal_email_id.should be == 'nana@gmail.com'
      response.should render_template 'employee/edit_personal_details_form'
    end

    it "should not update personal details without mandatory information" do
      profile = ModelFactory.create_profile
      Profile.should_receive(:find_by_email_id).with(:jesus).and_return(profile)
      details = {'emergency_contact_number' => '', 'title'=>'',
                 'marital_status'=>'', 'emergency_contact_person'=>'',
                 'personal_email_id'=>''}
      post :update, :profile => details
      Profile.find_by_id(profile.id).attributes.should_not include details
      response.should render_template 'employee/edit_personal_details_form'
    end
  end

  it "should show qualification details" do
    Profile.should_receive(:find_by_email_id).with(:jesus).and_return(:profile)
    get :qualifications
    assigns(:user_profile).should be == :profile
  end

  it "should show financial details" do
    Profile.should_receive(:find_by_email_id).with(:jesus).and_return(:profile)
    get :financial
    assigns(:user_profile).should be == :profile
  end

  it "should show experience details" do
    Profile.should_receive(:find_by_email_id).with(:jesus).and_return(:profile)
    get :experience
    assigns(:user_profile).should be == :profile
  end

  it "should show the warning message if the profile doesn't exist" do
    Profile.should_receive(:find_by_email_id).with(:jesus).and_return(nil)
    get :set_profile
    response.should render_template 'error_pages/warning'
  end

end
