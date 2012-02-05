require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "edit_passport" do
  before :each do
    profile = Profile.new
    passport = Passport.new
    assigns[:profile] = profile
    assigns[:passport] = passport
  end

  it "should load the confirmation prompt javascript" do
    render :template=>'passport/edit'
    response.body.should include('javascripts/confirmation_prompt.js')
  end

  it "should render submenu for employee" do
    @controller.set_current_user(User.employeeUser('bob'))
    render :template=>'passport/edit'
    response.body.should include("Employee's Passport Details")
  end

  it "should not render submenu for admin" do
    @controller.set_current_user(User.new :role => 'admin')
    render :template=>'passport/edit'
    response.body.should_not include("Employee's Passport Details")
  end

end