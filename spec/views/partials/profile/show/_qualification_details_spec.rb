require File.expand_path(File.dirname(__FILE__) + '/../../../../spec_helper')

describe "Qualification Details" do   
  
  before(:each) do
    @qualification = Qualification.new(
    :category=>'category',:degree=>'degree',:branch => 'branch',:college => 'college',:graduation_year => 1999
    )                        
    @qualifications = [@qualification,@qualification]
    @profile = Profile.new                          
    @controller.stub!(:check_authentication)
  end 
  
  it "should display the qualification information when qualifications are present" do
    @profile.qualifications = @qualifications
    render :partial =>'partials/profile/show/qualification_details', :locals=>{:profile=>@profile}
    response.should be_success                                                    

    response.should have_tag('h3','Educational Qualifications Details:')
    response.should have_tag('table') do
      with_tag('tr:nth-child(1)') do
      with_tag('th:nth-child(1)','Category')
      with_tag('th:nth-child(2)','Degree')
      with_tag('th:nth-child(3)', 'Branch')
      with_tag('th:nth-child(4)', 'University')
      with_tag('th:nth-child(5)', 'Graduation Year')
      end
      with_tag('tr:nth-child(2)') do
      with_tag('td:nth-child(1)', 'category')
      with_tag('td:nth-child(2)', 'degree')
      with_tag('td:nth-child(3)', 'branch')
      with_tag('td:nth-child(4)', 'college')
      with_tag('td:nth-child(5)', '1999')
      end
    end
    
  end
end