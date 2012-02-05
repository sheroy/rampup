require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ProfileController do
  before(:each) do                          
    @title = mock("title", :name=>'title')
    @location = mock("location", :Name=>'location')
    @titles = [@title, @title]                   
    @locations = [@location, @location]
    @controller.stub!(:check_authentication)
    @profile = Profile.new   
    @f = mock("form")
    ROLES=["Application Developer"] unless defined?(ROLES)
  end
  it "should render the various attributes of Employee master data " do    
    assigns[:profile] = @profile
    assigns[:titles] = @titles        
    assigns[:locations] = @locations             

    template.stub!(:render).with(:partial => 'partials/profile/general_details')
    template.stub!(:render).with(:partial => 'partials/profile/address_information')
    template.stub!(:render).with(:partial => 'partials/profile/transfer_details')
    template.stub!(:render).with(:partial => 'partials/picture/edit')
    render :template=>'profile/profile_form'
    response.should have_tag('a[href=/profiles]','Cancel')
  end
end