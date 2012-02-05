require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "visa partial" do
  it "should display the visa form if the passport information is already available" do
    @profile = Profile.new
    @visa = Visa.new
    @passport = Passport.new
    @profile.passport = @passport
    assigns[:profile] = @profile
    assigns[:visa] = @visa
    template.should_receive(:render).with(:partial=>'partials/visa/existing_visas')
    render :partial=>'partials/visa/visa'
    response.should be
    response.should have_tag('h3', "Visa Information")
  end
  it "should not display the visa form if no passport is found" do
    @profile = Profile.new
    assigns[:profile] = @profile
    render :partial=>'partials/visa/visa'
    response.should be
  end
end