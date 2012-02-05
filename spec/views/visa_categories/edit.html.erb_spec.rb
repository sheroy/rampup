require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/visa_categories/edit.html.erb" do
  include VisaCategoriesHelper
  
  before(:each) do
    assigns[:visa_category] = @visa_category = stub_model(VisaCategory,
      :new_record? => false
    )
  end

  it "should render edit form" do
    render "/visa_categories/edit.html.erb"
    
    response.should have_tag("form[action=#{visa_category_path(@visa_category)}][method=post]") do
    end
  end
end


