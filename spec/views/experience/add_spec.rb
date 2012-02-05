require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ExperienceController do
  before(:each) do
    @controller.stub!(:check_authentication)
    experience = mock("experience",
    :id=>1, :technology=>'java', :id=>'1', :last_used=>DateTime.parse('01/01/2009'), :duration=>62, :profile_id=>'1')
    params[:profile_id] = 1
    @profile = mock("Profile", :id=>1, :experiences => [experience],:common_name => 'Common Name')
    assigns[:profile]=@profile
    render :template=>'experience/add'
    response.should be_success
  end
  
  it "should display all the fields" do
    response.should have_tag("form[action='/experience/add/1']") do
      with_tag("input[name=years]")
      with_tag("input[name=months]")
    end
  end

  it "should go to Step 4 - Passport Information" do
    response.should have_tag("a[href=/passport/new/1]", :text => "Go To Next Step")
  end

end
