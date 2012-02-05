class NewJoineeChecklist < ActiveRecord::Base
  belongs_to :checklist_group

  def checked? profile_id
    EmployeeChecklistSubmitted.selected? profile_id,self.id
  end
end