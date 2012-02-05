require File.expand_path(File.dirname(__FILE__) + '/../../../../spec_helper')
describe "Role based breakdown" do
  it "should display the breakdown " do
    @role_breakdown={"Chennai_Application Developer"=>4}
    @controller.stub!(:check_authentication)
    template.should_receive(:render).with(:partial=>'partials/home/breakdowns/role', :locals=>{:role_breakdown=>@role_breakdown})
    render :partial=>'partials/admin/role_based_breakdown', :locals=>{:role_breakdown=>@role_breakdown}
    response.should be
    response.should have_tag('h3',"Title Based Distribution")
    response.should have_tag("a[href=/admin/export/role]","Export Table to Excel")
  end
end