require File.expand_path(File.dirname(__FILE__) + '/../../../../spec_helper')
describe "General details partial" do
  before(:each) do 
    @profile_attributes = {
      :name=>"Name",
      :common_name=>'Common-Name',
      :employee_id=>'12345',
      :date_of_birth=>'06/06/2009',
      :title=>'Application Developer',
      :gender=>'Male',
      :email_id=>'arvinda',
      :marital_status=>'Single',
      :guardian_name=>'Guardian Name',
      :date_of_joining=>'06/06/2009',
      :last_day=>'06/06/2009',
      :personal_email_id=>'aaa@gmail.com',
      :location_id=>'1',
      :years_of_experience=>'5',
      :type=>'ProfessionalServices'
    }                                                                       
    @profile = Profile.new
    @controller.stub!(:check_authentication)
  end 
  
  it "should display that email id is not set when it is not present in the profile" do
    @profile_attributes.delete(:email_id)
    @profile.attributes = @profile_attributes
    render :partial=>'partials/profile/show/general_details', :locals=>{:profile=>@profile}
    response.should be
    
    response.should have_tag('table') do
      with_tag('td', "--not set--")
    end

  end
  
  it "should display the general details properly" do
    @profile.attributes = @profile_attributes
    render :partial=>'partials/profile/show/general_details', :locals=>{:profile=>@profile}
    response.should be
    response.should have_tag('h3', "Personal Details: Common-Name")
    response.should have_tag("table") do
      with_tag("tr:nth-child(1)") do
        with_tag("td:nth-child(1)",:text=>'Employee Id:')
        with_tag("td:nth-child(2)",:text=>'12345')
      end
      with_tag('td', :text=>'Date of Birth:')
      with_tag('td', :text=>'6-Jun-2009')
      with_tag('td', :text=>'Role:')
      with_tag('td', :text=>'Application Developer')
      with_tag('td', :text=>'Gender:')
      with_tag('td', :text=>'Male')
      with_tag('td', :text=>'Email Id:')
      with_tag('td', :text=>'arvinda@thoughtworks.com')
      with_tag('td',:text=>'Personal Email Id:')
      with_tag('td',:text=>'aaa@gmail.com')
      with_tag('td', :text=>'Marital status:')
      with_tag('td', :text=>'Single') 
      with_tag('td', :text=>'Father Name:')
      with_tag('td', :text=>'Guardian Name')
      with_tag('td', :text=>'Date of joining:')
      with_tag('td', :text=>'6-Jun-2009')
      with_tag('td', :text=>'Last Day:')
      with_tag('td', :text=>'6-Jun-2009')
      with_tag('td',:text=>'Experience Prior To TWs:')
      with_tag('td',:text=>'0 yr 5 mth')
      with_tag('td', :text=>'Home Office:')
      with_tag('td', :text=>'Employee Id:')
    end
  end
end