require 'spec_helper'

describe EmployeeChecklistSubmitted do
  before(:each) do
    checklist_group = ChecklistGroup.new(:description=>"Group Description", :order => 1)
    checklist_group.save

    profile = Profile.new(:id =>1)
    profile.save(:validation => false)

    checklist= NewJoineeChecklist.new(:id=>1, :group_id => checklist_group.id, :description=>"checklist Description")
    checklist.save
    @valid_attributes = {
        :profile_id => profile.id,
        :new_joinee_checklists_id => checklist.id
    }

  end

  it "should create a new instance given valid attributes" do
    EmployeeChecklistSubmitted.create!(@valid_attributes)
  end

  it "should clear all checklists for specific employee id" do
    EmployeeChecklistSubmitted.clear_checklists(@valid_attributes[:profile_id])
    EmployeeChecklistSubmitted.find_all_by_profile_id(@valid_attributes[:profile_id]).size.should == 0
  end

  it "should return true when a specific checklist exists" do
    EmployeeChecklistSubmitted.create!(@valid_attributes)
    EmployeeChecklistSubmitted.selected?(@valid_attributes[:profile_id],@valid_attributes[:new_joinee_checklists_id] ) .should == true
  end

end
