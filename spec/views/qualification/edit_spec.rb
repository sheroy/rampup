require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Edit" do

  it "should show a Cancel button" do
    qualifications = mock "Qualifications mock", :size => 0
    profile = mock "Profile mock", :qualifications => qualifications, :id => 1
    qualification = mock "Qualification mock", :profile_id => 1, :profile => profile
    Qualification.stub(:find_by_id).and_return qualification
    qualification.stub(:graduation_year)
    qualification.stub(:degree)
    qualification.stub(:branch)
    qualification.stub(:category)
    qualification.stub(:college)
    params[:id] = 1
    assigns[:profile] = profile
    assigns[:qualification] = qualification
    render :template=>'qualification/edit'
    response.should have_tag("a[href=/qualification/add/1]", :text => "Cancel")
  end
end