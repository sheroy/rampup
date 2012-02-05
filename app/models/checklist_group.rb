class ChecklistGroup < ActiveRecord::Base
  has_many :new_joinee_checklists

  def self.sort_by_order
    ChecklistGroup.find_by_sql("select * from checklist_groups
                                ORDER BY checklist_groups.order")
  end
end