require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdminController do
  it "should render the breakdown page" do
    Profile.should_receive(:role_and_location_wise_breakdown)
    Profile.should_receive(:qualification_category_in_location)
    HashGenerator.should_receive(:convert_to_hash).at_most(2)
    get :breakdown
    response.should be_success
  end

  it "should export the excel file with role distributions" do                                
    Profile.should_receive(:role_and_location_wise_breakdown).and_return()
    HashGenerator.should_receive(:convert_to_hash)
    @controller.should_receive(:render).with(:partial => 'partials/home/breakdowns/role',
    :locals=>{:role_breakdown=>@role_breakdown},:layout=>false)
    get :role_exporter
    response.should be
  end
  
  it "should export the excel file with qualification breakdown" do
    Profile.should_receive(:qualification_category_in_location)
     HashGenerator.should_receive(:convert_to_hash)
    @controller.should_receive(:render).with(:partial=>'partials/home/breakdowns/qualification',
    :locals=>{:qualification_breakdown=>@qualification_breakdown},:layout=>false)
    get :qualification_distribution_exporter
    response.should be
  end
end
