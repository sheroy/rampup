require "spec_helper"

describe "FinancialView" do

  it "should display financial details" do
      profile=ModelFactory.create_profile
      assigns[:user_profile]=profile
      template.should_receive(:render).with(:partial => 'partials/profile/show/financial_details', :locals => {:profile => profile})
      render :template => 'employee/financial'
  end
end