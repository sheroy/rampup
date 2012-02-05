require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ProfileController do
  before(:each) do                          
    @profile = Profile.new(:id=>1)
    @controller.stub!(:check_authentication)
  end
  describe "show" do
    it "should display the employee profile properly" do
      @controller.set_current_user(User.new(:role=>"admin"))
      template.should_receive(:render).with(:partial=>'partials/profile/show/general_details',:locals=>{:profile=>@profile})
      template.should_receive(:render).with(:partial=>'partials/profile/show/address_details',:locals=>{:profile=>@profile})
      template.should_receive(:render).with(:partial=>'partials/profile/show/access_card_details',:locals=>{:profile=>@profile})
      template.should_receive(:render).with(:partial=>'partials/picture/show',:locals=>{:profile=>@profile})
      template.should_receive(:render).with(:partial=>'partials/profile/show/qualification_details',
        :locals=>{:profile=>@profile})

      template.should_receive(:render).with(:partial=>'partials/profile/show/experience_details',
        :locals=>{:profile=>@profile})
      template.should_receive(:render).with(:partial=>'partials/passport/passport_information', :locals=>{:profile=>@profile,:passport=>@profile.passport})
      template.should_receive(:render).with(:partial=>'partials/profile/show/life_insurance_details', :locals=>{:profile=>@profile})
      template.should_receive(:render).with(:partial=>'partials/profile/show/medical_insurance_details', :locals=>{:profile=>@profile})
      template.should_receive(:render).with(:partial=>'partials/profile/show/financial_details', :locals=>{:profile=>@profile})
      assigns[:profile] = @profile
      assigns[:passport] = @profile.passport
      render :template=>'profile/show'
      response.should be
      response.should have_tag("a[href=/profile/edit/#{@profile.id}]", "Edit Profile")
      response.should have_tag("a", "Employee Resigns")
      response.should have_tag("a[href=/profiles]", "Back")
      response.should have_tag('h3','Passport Details:')

    end

   it "should not display employee_resigns and edit profile links for exit employees" do
    assigns[:profile] = ModelFactory.create_profile(:last_day => DateTime.now)
    render :template=>'profile/show'
    response.should be
    response.should_not have_tag("a", "Employee Resigns")
    response.should_not have_tag("a","Edit Profile")
   end


  end
end