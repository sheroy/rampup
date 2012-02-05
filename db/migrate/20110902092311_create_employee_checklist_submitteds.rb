class CreateEmployeeChecklistSubmitteds < ActiveRecord::Migration
  def self.up
    create_table 'employee_checklist_submitteds' do |t|
      t.integer :profile_id
      t.integer :new_joinee_checklists_id
    end
    add_foreign_key(:employee_checklist_submitteds, :new_joinee_checklists,
                    :column=>"new_joinee_checklists_id", :dependent => :delete)
    add_foreign_key(:employee_checklist_submitteds, :profiles,
                    :column=>"profile_id", :dependent => :delete)
  end

  def self.down
    remove_foreign_key(:employee_checklist_submitteds, :column=>"new_joinee_checklists_id")
    remove_foreign_key(:employee_checklist_submitteds, :column=>"profile_id")
    drop_table 'employee_checklist_submitteds'
  end
end
