class CreateChecklistTable < ActiveRecord::Migration
  def self.up
    create_table 'new_joinee_checklists', :force => true do |t|
      t.string "description", :null => false
    end
  end

  def self.down
    drop_table 'new_joinee_checklists'
  end
end
