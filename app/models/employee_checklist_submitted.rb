class EmployeeChecklistSubmitted < ActiveRecord::Base
  def self.selected? profile_id, checklist_id
    conditions = {:profile_id=> profile_id, :new_joinee_checklists_id=>checklist_id}
    !EmployeeChecklistSubmitted.find(:all, :conditions => conditions).empty?
  end

  def self.clear_checklists profile_id
    EmployeeChecklistSubmitted.delete_all(:profile_id=>profile_id)
  end

end

