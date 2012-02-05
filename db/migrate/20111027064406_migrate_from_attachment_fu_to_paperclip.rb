require "migration_helpers"

class MigrateFromAttachmentFuToPaperclip < ActiveRecord::Migration
  include PaperclipMigrations

  def self.up
    create_table "profile_pictures", :force => true do |t|
      t.integer "profile_id"
      t.integer "parent_id"
    end
    add_index "profile_pictures", ["profile_id"], :name => "fk_profile_pictures_profile_id"

    add_paperclip_fields :profile_pictures, :photo

    ProfilePicture.reset_column_information

    Picture.all.each do |pic|
      if pic.thumbnail.nil?
        profile = Profile.find_by_id(pic.profile_id)
        profile_pic = ProfilePicture.new
        profile_pic.profile_id = pic.profile_id
        profile_pic.parent_id = pic.parent_id
        populate_paperclip_from_attachment_fu(profile_pic, pic, :photo)
        profile.profile_picture = profile_pic
        profile.save
      end
    end

    #remove_column :pictures, :content_type
    #remove_column :pictures, :filename
    #remove_column :pictures, :thumbnail
    #remove_column :pictures, :size
    #remove_column :pictures, :width
    #remove_column :pictures, :height


  end

  def self.down
    puts "This database migration is unable to be rolled back."
    puts "This is due to switching from Attachment_Fu to Paperclip which required changes in the code, making an Attachment_Fu database incompatible."
    puts "Please roll back to git commit de9ff75bcd1f496694c674f88f2cbc3788ba34c4 - 'David/Peter: #148 added the paperclip gem to the gemfile' to get Attachment_Fu functionality"
  end
end