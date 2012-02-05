require "spec_helper"

describe "QualificationView" do

  it "should display qualification details" do
    profile = ModelFactory.create_profile
    assigns[:user_profile] = profile
    template.should_receive(:render).with(:partial => 'partials/profile/show/qualification_details', :locals=>{:profile=>profile})
    render :template => 'employee/qualifications'
  end
end