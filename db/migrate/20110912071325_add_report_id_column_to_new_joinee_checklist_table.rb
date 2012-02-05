class AddReportIdColumnToNewJoineeChecklistTable < ActiveRecord::Migration
  def self.up
    add_column :new_joinee_checklists, :report_id, :integer
  end

  def self.down
  end
end
