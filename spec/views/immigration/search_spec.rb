require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
describe "Search Results" do                                             
  before(:each) do
    @passport = mock("Passport", :id=>1,
    :number => "Number",
    :date_of_expiry => DateTime.parse("10/10/2009")
    )
    @profile = mock("Profile", :id=>1,
    :common_name => "name",
    :title => "title",
    :location => "location",
    :employee_id => "12509",
    :passport => @passport)
  end                            
  it "should display no search results found when no searches matches the query" do
    assigns[:profiles]=[]     
    render :template => 'immigration/search'
    response.should be_success
    response.should have_tag('h3',"No Search Results Found.")
  end
  it "should display the employee id , name, title, location, passport_no" do       
    pending "Assert for Pagination . Temporary Pending"
    assigns[:profiles] = Profile.paginate(:all, :limit=>10, :per_page=>10, :page=>1)
    render :template => 'immigration/search'
    response.should be_success
    response.should have_tag('table') do
      with_tag('tr:nth-child(1)') do
        with_tag('th:nth-child(1)',"Employee ID")
        with_tag('th:nth-child(2)',"Name")
        with_tag('th:nth-child(3)',"Title")
        with_tag('th:nth-child(4)',"Location")
        with_tag('th:nth-child(5)',"Passport No")
        with_tag('th:nth-child(6)',"Expiry Date")
      end
    end
  end
end