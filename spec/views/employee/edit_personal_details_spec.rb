require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe EmployeeController do
  before(:each) do                          
    @controller.stub!(:check_authentication)
    @profile = Profile.new
  end
  it "should render the various attributes of Employee personal details " do
    assigns[:user_profile] = @profile
    template.stub!(:render).with(:partial => 'partials/employee/general_details')
    template.stub!(:render).with(:partial => 'partials/employee/address_details')
    template.stub!(:render).with(:partial => 'partials/employee/access_card_details')
    render :template=>'employee/edit_personal_details_form'
    response.should have_tag('a[href=/employee]','Cancel')
  end

  it "should load the confirmation prompt javascript" do
    assigns[:user_profile] = @profile
    template.stub!(:render).with(:partial => 'partials/employee/general_details')
    template.stub!(:render).with(:partial => 'partials/employee/address_details')
    template.stub!(:render).with(:partial => 'partials/employee/access_card_details')
    render :template=>'employee/edit_personal_details_form'
    response.body.should include('javascripts/confirmation_prompt.js')
  end
end