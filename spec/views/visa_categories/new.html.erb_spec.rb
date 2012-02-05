require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/visa_categories/new.html.erb" do
  include VisaCategoriesHelper
  
  before(:each) do
    assigns[:visa_category] = stub_model(VisaCategory,
      :new_record? => true
    )
  end

  it "should render new form" do
    render "/visa_categories/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", visa_categories_path) do
    end
  end
end


