require "spec_helper"

describe "Edit" do

  before :each do
    profile = mock "Profile mock", :id => 1
    experience = mock "Experience mock", :profile => profile, :profile_id => 1
    assigns[:experience] = experience
    @controller.stub(:render)
    render :template=>'experience/edit'
  end

  it "should show a Save button" do
    response.should have_tag("input[type=submit][value=Save]")
  end

  it "should show a Cancel button" do
    response.should have_tag("a[href=/experience/add/1]", :text => "Cancel")
  end

  it "should go to Step 4 - Passport Information" do
    response.should have_tag("a[href=/passport/new/1]", :text => "Go To Next Step")
  end

end