class CreateAttachedDocument < ActiveRecord::Migration
  def self.up
    create_table :attached_documents do |t|
      t.integer :parent_id
      t.integer :profile_id
      t.string   :document_file_name
      t.string   :document_content_type
      t.integer  :document_file_size
      t.datetime :document_updated_at
      t.timestamps
      t.string :name
      t.string :document_type
    end
  end

  def self.down
    drop_table :attached_documents
  end
end