require File.expand_path(File.dirname(__FILE__) + '/../../../../spec_helper')

describe "Medical Insurance Details" do
  before(:each) do
    @medical=Medical.new(:name=>'Name',:relationship=>'relation',:date_of_birth=>DateTime.now - 8.years)
    @medicals=[@medical,@medical,@medical]
    @profile=Profile.new
    @profile.medicals=@medicals
  end

  it "should display the life insurance dependents details when it is present" do
    assigns[:profile]=@profile
    render :partial=>'partials/profile/show/medical_insurance_details',:locals=>{:profile=>@profile}
    response.should be
    response.should have_tag('h3','Medical Insurance Details:')
    response.should have_tag('table') do
      with_tag('tr:nth-child(1)') do
        with_tag('th:nth-child(1)','Name')
        with_tag('th:nth-child(2)','Relationship')
        with_tag('th:nth-child(3)','Date Of Birth')
        with_tag('th:nth-child(4)','Age')
      end
      with_tag('tr:nth-child(2)') do
        with_tag('td:nth-child(1)','Name')
        with_tag('td:nth-child(2)','relation')
        with_tag('td:nth-child(3)', custom_date_with_month((Time.now.to_date-8.years)))
        with_tag('td:nth-child(4)','8')
      end
    end
  end
end