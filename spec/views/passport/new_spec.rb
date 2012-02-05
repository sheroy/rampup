require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Passport new page" do
  it "should display the form for a new passport" do
    @profile = Profile.new
    @passport = Passport.new
    assigns[:passport] = @passport
    assigns[:profile] = @profile
    template.should_receive(:render).with(:partial=>'partials/passport/passport')
    render :template => 'passport/new'
    response.should have_tag('h3',"Passport and Visa Details")
  end
end