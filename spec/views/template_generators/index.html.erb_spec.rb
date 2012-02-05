require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/template_generators/index.html.erb" do
  include TemplateGeneratorsHelper
  it "should render list of template_generators" do

    template1=TemplateGenerator.create!(:name=>'name1',:file_name=>'file_name', :document_type=>true,:selected=>true)
    template2=TemplateGenerator.create!(:name=>'name2',:file_name=>'file_name', :document_type=>false,:selected=>true)
    template3=TemplateGenerator.create!(:name=>'name3',:file_name=>'file_name', :document_type=>true,:selected=>false)
    template4=TemplateGenerator.create!(:name=>'name4',:file_name=>'file_name', :document_type=>false,:selected=>false)
    assigns[:mandatory_template_generators] = [template1,template3]
    assigns[:optional_template_generators] = [template2,template4]
    render "/template_generators/index.html.erb"
    response.should be
    response.should have_tag('div.template-left') do 
      [template1, template3].each do |template|
        with_tag("li", /#{template.name}/)
      end
    end
    response.should have_tag('div.template-right') do 
      [template2, template4].each do |template|
        with_tag("li", /#{template.name}/)
      end
    end
  end
end

