require "spec_helper"

describe "Edit" do

before :each do
  profile = mock "Profile mock", :id => 1
  assigns[:profile] = profile
  life_insurance = mock "Life insurance mock", :id => 1
  assigns[:life_insurance] = life_insurance

  @controller.stub(:render)

  render :template=>'insurance/edit_life_insurance'
end

  it "should show a Cancel button" do
    response.should have_tag("a[href=/insurance/new_life_insurance/1]", :text => "Cancel")
  end

  it "should show a Save button" do
    response.should have_tag("input[type=submit][value=Save]")
  end

end