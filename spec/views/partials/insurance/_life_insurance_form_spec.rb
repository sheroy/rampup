require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "Life Insurance Form" do
  before :each do
    assigns[:life_insurance] = Life.new
    assigns[:profile] = Profile.new
    render :partial=>'partials/insurance/life_insurance_form'
  end

  it "should render the form properly" do
    response.should be_success
  end

  it "should have the Add New Life Insurance button" do
    response.should have_tag("input[type=submit][value=Add Life Insurance Information]")
  end

end