require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "QualificationController" do
  before(:each) do
    @controller.stub!(:check_authentication)
    qualification = mock("Qualification")
    @profile = mock("profile", :qualification => [qualification],:common_name => 'Common Name')
    @profile.stub!(:qualification)
    qualification.should_receive(:graduation_year)
    qualification.should_receive(:degree)
    qualification.should_receive(:branch)
    qualification.should_receive(:category)
    qualification.should_receive(:college)
    params[:profile_id] = 1
    assigns[:profile]=Profile.new
    assigns[:qualification] = qualification
    Profile.should_receive(:find_by_id).with(params[:profile_id]).and_return(@profile)
  end
  describe "add" do
    it "should render all the fields" do
      render :template=>'qualification/add'
      response.should be_success 
      response.should have_tag('h3',/Common Name/)
      response.should have_tag('h3',/Step 2 of 6 - Qualification Details/)
      response.should  have_tag('h3',/Add New Qualification/)
      response.should have_tag("form[action='/qualification/add/1']") do
      end
    end
    
    it "should validate Go To Next Step option" do
      params[:profile_id] = 1
      render :template=>'qualification/add'
      response.should be_success
      response.should have_tag("a[href=/qualification/validate/1]", :text => "Go To Next Step")
    end
  end
end