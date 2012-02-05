require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../model_factory'

describe NewJoineeChecklist do
  before(:each) do
    #@checklist = NewJoineeChecklist.first
    @checklist = NewJoineeChecklist.find_or_create_by_description('6 Passport size photographs', :group_id=>ChecklistGroup.find_or_create_by_description('Photographs', :order=>1).id, :checklist_id=>1, :report_column_name=>"Passport Photos")
  end

  it "should return false for specific profile id when checkbox is not checked" do
    profile = ModelFactory.create_profile(:id=>12345)
    status = @checklist.checked? profile.id
    status.should be false
  end

  it "should return true for specific profile id when checkbox is checked" do
    profile = ModelFactory.create_profile(:id=>88888)
    checklist_submiitted = EmployeeChecklistSubmitted.create(:profile_id => profile.id, :new_joinee_checklists_id=>@checklist.id)
    checklist_submiitted.save
    EmployeeChecklistSubmitted.count.should == 1
    status = @checklist.checked? profile.id
    status.should be true
  end
end
