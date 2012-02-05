require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "Passport Partial" do
  it "should display the passport form if passport information is not present" do
    @passport = Passport.new
    @profile = Profile.new
    assigns[:passport] = @passport
    assigns[:profile] = @profile
    template.should_receive(:render).with(:partial=>'partials/passport/passport_form',
    :locals=>{:passport => @passport, :profile=>@profile})
    render :partial=>'partials/passport/passport'
    response.should be
    response.should have_tag('h3',"Passport Information for --Not-Set--")
  end
  it "should display the passport information if the passport information is already available" do
    @passport = Passport.new
    @profile = Profile.new
    @profile.passport = @passport
    assigns[:passport] = @passport
    assigns[:profile] = @profile
    template.should_receive(:render).with(:partial=>'partials/passport/passport_information',
    :locals=>{:passport => @passport, :profile=>@profile})
    render :partial=>'partials/passport/passport'
    response.should be
    response.should have_tag('h3',"Passport Information for --Not-Set--")
  end
end