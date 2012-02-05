require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
describe "Breakdown" do
  before(:each) do
    @role_breakdown={"Chennai_Application Developer"=>4}
    @places =["Chennai","Bangalore","Pune"]
    @qualification_breakdown={"Chennai_UG-masters"=>5}
    @qualifications=['qualification','qualification','qualification']
  end
  it "should have the role based and qualification based breakdowns" do
    assigns[:role_breakdown]=@role_breakdown
    assigns[:roles]=@roles
    assigns[:places]=@places
    assigns[:qualification_breakdown]=@qualification_breakdown
    assigns[:qualifications]=@qualifications
    template.should_receive(:render).with(:partial=>'partials/admin/role_based_breakdown',
      :locals=>{:role_breakdown=>@role_breakdown})
    template.should_receive(:render).with(:partial=>'partials/admin/qualification_based_breakdown',:locals=>{:qualification_breakdown=>@qualification_breakdown})
    render :template=>'admin/breakdown'
    response.should be_success
  end
end