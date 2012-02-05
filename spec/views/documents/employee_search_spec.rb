require "spec_helper"

describe "Employee Search View" do
  it "should render a search button"do
     render :template=>'document/employee_search'
    response.should have_tag("input[value = Search]")
  end

  it "should render search results"do
    profile=ModelFactory.create_profile
    assigns[:profiles]=[profile]
    template.should_receive(:render).with(:partial => 'partials/profiles/profiles_list_without_edit',:locals=>{:profiles=>[profile]})
    render :template=>'document/show_results'
  end

  it "should have a view or upload documents button"do
     profile=ModelFactory.create_profile
    assigns[:profiles]=[profile]
    render :template=>'document/show_results'
    response.should have_tag("input[value =View or Upload Documents]")
  end
end