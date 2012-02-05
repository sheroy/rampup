require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

describe Emailer do
  it "should send emails" do
    userProfile = ModelFactory.create_profile
    email = Emailer.deliver_notify(userProfile)
    ActionMailer::Base.deliveries.empty?.should == false
    email.subject.should == "[RampUp] Mohan has modified his/her profile." 
    email.to.should include('rampup_admin@thoughtworks.com')
    email.from.should include('no-reply@thoughtworks.com')
  end
end
