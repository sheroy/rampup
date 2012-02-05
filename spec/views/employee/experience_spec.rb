require "spec_helper"

describe "Experience View" do

  it "should display experience details" do
      profile=ModelFactory.create_profile
      assigns[:user_profile]=profile
      template.should_receive(:render).with(:partial => 'partials/profile/show/experience_details', :locals => {:profile => profile})
      render :template => 'employee/experience'
  end
end