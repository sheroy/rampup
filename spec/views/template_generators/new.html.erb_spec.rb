require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/template_generators/new.html.erb" do
  include TemplateGeneratorsHelper
  it "should render new form" do
    render"/template_generators/new.html.erb"
    
    response.should have_tag("form") do
      with_tag("input#template_generator_name[name=?]", "template_generator[name]")
      with_tag("input[name=?]", "upload_spreadsheet[datafile]")
      with_tag("input[name=?]", "template_generator[document_type]")
    end
  end
end


