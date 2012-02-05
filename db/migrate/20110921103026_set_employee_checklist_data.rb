class SetEmployeeChecklistData < ActiveRecord::Migration
  def self.up
    profiles = Profile.all
    checklists = NewJoineeChecklist.all
    profiles.each do |profile|
      checklists.each do |checklist|
        EmployeeChecklistSubmitted.create(:profile_id => profile.id, :new_joinee_checklists_id => checklist.id)
      end
    end

  end

  def self.down
    profiles = Profile.all
    profiles.each do |profile|
      profile.employee_checklist_submitteds.destroy_all()
    end
  end
end
