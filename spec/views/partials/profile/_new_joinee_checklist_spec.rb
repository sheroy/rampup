require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe ProfileController do
  before(:each) do
    @profile = Profile.new(:id=>1)
    @controller.stub!(:check_authentication)
    @controller.set_current_user(User.new(:role=>"employee"))
  end
  describe "show" do
    it "should show a link to new joinee checklist in employee view " do

      template.should_receive(:render).with(:partial=>'partials/profile/show/general_details',:locals=>{:profile=>@profile})
      template.should_receive(:render).with(:partial=>'partials/profile/new_joinee_checklist_link',:locals=>{:profile=>@profile})
      assigns[:profile] = @profile
      render :template=>'profile/show'
      response.should be

    end

 end
     describe "employees view checklist " do
      it "should not be editable by employees" do
        assigns[:profile] = @profile
        @checklistgroup1 = mock("ChecklistGroupRecord")
        @checklistgroup1.stub!(:report_column_name).and_return("item1")
        @checklistgroup1.stub!(:description).and_return("description1")
        @checklistgroup1.stub!(:id).and_return("1")

        assigns[:checklist_groups] =[ @checklistgroup1]

        @checklist1 = mock("ChecklistitemRecord")
        @checklist1.stub!(:group_id).and_return("1")
        @checklist1.stub!(:checked?).and_return("true")
        @checklist1.stub!(:description).and_return("checkItemDescription")
        assigns[:checklists]=[@checklist1]

        render :template=>'profile/new_joinee_checklist'
        assert_tag "input", :attributes => {:disabled => true}
        end
    end
end