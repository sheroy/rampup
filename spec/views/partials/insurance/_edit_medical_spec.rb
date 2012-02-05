require "spec_helper"

describe "Edit" do
  before :each do
    @controller.stub(:render)
    medical = mock "Medical mock", :id => 1
    profile = mock "Profile mock", :id => 1
    render :partial => "partials/insurance/edit_medical", :locals => {:medical => medical, :profile => profile}
  end

  it "should show a Save button" do
    response.should have_tag "input[type=submit][value=Save]"
  end

  it "should show a Cancel button" do
    response.should have_tag("a[href=/insurance/new_life_insurance/1]", :text => "Cancel")
  end
end