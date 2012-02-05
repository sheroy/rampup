require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "Existing Visas" do
  it "should display the list of available visas correctly" do
    @visa = mock("visa",
      :id=>'1',
      :issue_date => Time.parse('10/10/2009'),
      :expiry_date => Time.parse('10/10/2009'),
      :status => Time.parse('10/10/2009'),
      :appointment_date => Time.parse('10/10/2009'),
      :petition_status => 'status',
      :timeline => 'time-line',
      :reason => 'reason',
      :visa_type => 'type',
      :country => 'country',
      :date_of_return => Time.parse('10/10/2009'),
      :travel_by => Time.parse('10/10/2009'),
      :category => 'category'
    )
    @profile = mock("profile", :name=>'profile', :visas=>[@visa,@visa,@visa],:id=>'1')
    
    assigns[:profile] = @profile
    render :partial => 'partials/visa/existing_visas'
    
    response.should be_success
    
    response.should have_tag('table') do

    end
    
    
  end
  
  it "should not display anything" do
    @visa = mock("visa",
      :issue_date => Time.parse('10/10/2009'),
      :expiry_date => Time.parse('10/10/2009'),
      :status => Time.parse('10/10/2009')
    )
    @profile = mock("profile", :name=>'profile', :visas=>nil)
    
    assigns[:profile] = @profile
    render :partial => 'partials/visa/existing_visas'
    
    response.should be_success
    
    response.should_not have_tag('h3', "Existing Visas")
    
  end
  
end