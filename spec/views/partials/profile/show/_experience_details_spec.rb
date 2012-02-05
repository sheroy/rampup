require File.expand_path(File.dirname(__FILE__) + '/../../../../spec_helper')

describe "Experience details" do                    
  before(:each) do
    @experience = Experience.new(
    :technology => 'java',
    :last_used => DateTime.parse('10/10/2009'),
    :duration => 10)       
    @experiences = [@experience, @experience]                                            
    @profile = Profile.new
    @profile.experiences = @experiences
  end                                                                                         

  it "should display the experience when its present" do
    render :partial=>'partials/profile/show/experience_details', :locals=>{:profile=>@profile}
    response.should be 
    response.should have_tag('table') do
      with_tag('th','Technology')
      with_tag('th', 'Last Used')
      with_tag('th', 'Duration')
      with_tag('td', 'java')
      with_tag('td', "Oct-2009")
      with_tag('td', "0 yr 10 mth")
    end
  end
end
