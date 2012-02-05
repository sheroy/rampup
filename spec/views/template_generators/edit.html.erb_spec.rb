require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/template_generators/edit.html.erb" do
  include TemplateGeneratorsHelper
  
  before(:each) do
    assigns[:template_generator] = @template_generator = stub_model(TemplateGenerator,
      :new_record? => false,
      :location => "value for location",
      :selected => false
    )
  end

  it "should render edit form" do
    render "/template_generators/edit.html.erb"
    response.should have_tag("form") do
      with_tag("input#template_generator_name[name=?]", "template_generator[name]")
      with_tag("input[name=?]", "template_generator[document_type]")
    end
  end
end


