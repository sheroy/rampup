class CreateReportColumnNameInNewJoineeChecklist < ActiveRecord::Migration
  def self.up
    add_column :new_joinee_checklists, :report_column_name, :string
    rename_column :new_joinee_checklists, :report_id, :checklist_id
  end

  def self.down
  end
end
