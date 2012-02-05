require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "edit visa" do
   it "should display the form for editing visa information" do
    @visa = Visa.new
    @profile = Profile.new
    assigns[:profile] = @profile
    assigns[:visa]=@visa
   # template.should_receive(:render).with(:partial=>'partials/visa/visa_information',:locals=>{:visa=>@visa,:f=>f})
    render :partial=>'partials/visa/edit_visa', :locals=>{:visa=>@visa}
    response.should be_success
  end
end