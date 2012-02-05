# module MigrationHelpers
#   def foreign_key(child_table, child_column, parent_table, parent_column)
#     constraint_name = "fk_#{child_table}_#{child_column}"
# 
#     execute %{alter table #{child_table}
#     add constraint #{constraint_name}
#     foreign key (#{child_column})
#     references #{parent_table}(#{parent_column})}
#   end
# 
#   def remove_foreign_key(child_table,child_column)
#     constraint_name = "fk_#{child_table}_#{child_column}" 
#     execute %{alter table #{child_table}
#     drop foreign key #{constraint_name}}
#   end
# end
# 
# SQL SERVER specific migration
module MigrationHelpers
  def foreign_key(child_table, child_column, parent_table, parent_column)
    constraint_name = "fk_#{child_table}_#{child_column}"

    execute %{alter table #{child_table}
    add constraint #{constraint_name}
    foreign key (#{child_column})
    references #{parent_table}(#{parent_column})}
  end

  def remove_foreign_key(child_table,child_column)
    constraint_name = "fk_#{child_table}_#{child_column}" 
    execute %{alter table #{child_table}
    drop constraint #{constraint_name}}
  end
end

module PaperclipMigrations

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def add_paperclip_fields(table, prefix)
      add_column table, "#{prefix}_file_name", :string
      add_column table, "#{prefix}_content_type", :string
      add_column table, "#{prefix}_file_size", :integer
      add_column table, "#{prefix}_updated_at", :datetime
    end

    def populate_paperclip_from_attachment_fu(model, attachment, prefix)
      unless attachment.filename.nil?
        model.send("#{prefix}_file_name=", attachment.filename)
        model.send("#{prefix}_content_type=", attachment.content_type)
        model.send("#{prefix}_file_size=", attachment.size)
        model.save

        old_path = File.join(Rails.root, 'public/system/pictures/0000', attachment.id.to_s.rjust(4,"0"), attachment.filename)
        new_path = File.join(Rails.root, 'public/profiles/pictures', model.id.to_s, attachment.filename)
        new_folder = File.dirname(new_path)

        unless File.exists?(new_folder)
          FileUtils.mkdir_p(new_folder)
        end

        if File.exists?(old_path)
          puts "Moving attachment_fu file from #{old_path} to #{new_path}"
          #File.copy(File.new(old_path,"r"), File.new(new_path,"w+"))
          File.copy(old_path, new_path  )
        else
          puts "No such file: #{old_path}"
        end
      end
    end
  end
end