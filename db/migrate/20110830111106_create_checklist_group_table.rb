class CreateChecklistGroupTable < ActiveRecord::Migration
  def self.up
    create_table "checklist_groups",:force => true do |t|
      t.string "description"
      t.integer "order", :null => false
    end
  end

  def self.down
    drop_table "checklist_groups"
  end
end
