require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/template_generators/show.html.erb" do
  include TemplateGeneratorsHelper
  
  before(:each) do
    assigns[:template_generator] = @template_generator = stub_model(TemplateGenerator,
      :location => "value for location",
      :selected => false
    )
  end

  it "should render attributes in <p>" do
    render "/template_generators/show.html.erb"
    response.should have_text(/value\ for\ location/)
    response.should have_text(/als/)
  end
end

