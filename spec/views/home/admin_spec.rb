require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
describe "Admin" do
  before(:each) do
    employee = mock("New Joinee", :employee_id=>'12509',:name=>'name',:title=>'title',:location=>'location',:date_of_joining => Time.parse('10/10/2009'))
    @new_joinees = [employee,employee,employee,employee]
    @places =["Chennai","Bangalore","Pune"]
    @controller.stub!(:check_authentication)
    @head_count_breakdown=[[1,2,3],[1,2,3],[1,2,3]]
    @employee_type=["ProfessionalServices","Support","ETG"]
  end
  describe "home page" do
    it  " should have the head count count breakdown and new joiniees " do
      assigns[:new_joinees] = @new_joinees
      assigns[:places] = @places
      assigns[:head_count_breakdown] = @head_count_breakdown
      assigns[:employee_type]=@employee_type
      template.should_receive(:render).with(:partial=>"partials/home/new_joinees",:locals=>{:new_joinees=>@new_joinees})
      render :template=>"home/admin"
      response.should be
    end
  end
end