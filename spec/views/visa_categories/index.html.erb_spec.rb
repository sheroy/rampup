require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/visa_categories/index.html.erb" do
  include VisaCategoriesHelper
  
  before(:each) do
    assigns[:visa_categories] = [
      stub_model(VisaCategory),
      stub_model(VisaCategory)
    ]
  end

  it "should render list of visa_categories" do
    render "/visa_categories/index.html.erb"
  end
end

