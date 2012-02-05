class CreateSignatures < ActiveRecord::Migration
  def self.up
    create_table :signatures do |t|
      t.string :name
      t.string :signature
    end
  end

  def self.down
    drop_table :signatures
  end
end


