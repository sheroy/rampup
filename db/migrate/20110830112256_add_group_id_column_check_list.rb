require 'foreigner'
class AddGroupIdColumnCheckList < ActiveRecord::Migration
  def self.up
    add_column 'new_joinee_checklists', "group_id", :integer, :null=> false
    add_foreign_key(:new_joinee_checklists, :checklist_groups,
                    :column=>"group_id", :dependent => :delete)

  end

  def self.down
    remove_foreign_key(:new_joinee_checklists,:column => "group_id")
    remove_column "new_joinee_checklists", "group_id"

  end
end
