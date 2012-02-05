class CreateLetterheads < ActiveRecord::Migration
  def self.up
    create_table :letterheads do |t|
      t.string "office_name", :null => false
      t.string "template_path", :null => false
    end

    Letterhead.find_or_create_by_office_name('Gurgaon', :template_path => "doc/templates/Gurgaon Letterhead.pdf")
    Letterhead.find_or_create_by_office_name('Pune', :template_path => "doc/templates/Pune Letterhead.pdf")
    Letterhead.find_or_create_by_office_name('Bangalore', :template_path => "doc/templates/Bangalore Letterhead.pdf")
    Letterhead.find_or_create_by_office_name('Chennai', :template_path => "doc/templates/Chennai Letterhead.pdf")
  end

  def self.down
    drop_table :letterheads
  end
end
