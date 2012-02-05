require File.expand_path(File.dirname(__FILE__) + '/../../../../spec_helper')
describe "Life Insurance Details" do
  before(:each) do
    @life=Life.new(:name=>'Name',:relationship=>'relation',:percentage=>10,:date_of_birth=>DateTime.parse('10/10/2000'))
    @lives=[@life,@life,@life]
    @profile=Profile.new
    @profile.lives=@lives
  end

  it "should display the life insurance dependents details when it is present" do
    assigns[:profile]=@profile
    render :partial=>'partials/profile/show/life_insurance_details',:locals=>{:profile=>@profile}
    response.should be
    response.should have_tag('h3','Life Insurance Details:')
    response.should have_tag('table') do
      with_tag('tr:nth-child(1)') do
        with_tag('th:nth-child(1)','Name')
        with_tag('th:nth-child(2)','Relationship with Employee')
        with_tag('th:nth-child(3)','Percentage')
      end
      with_tag('tr:nth-child(2)') do
        with_tag('td:nth-child(1)','Name')
        with_tag('td:nth-child(2)','relation')
        with_tag('td:nth-child(3)','10')
      end
    end
  end
end