Factory.define :profile_picture do |f|
  f.profile_id nil
  f.parent_id nil
  f.photo_file_name "image"
  f.photo_content_type "image/png"
  f.photo_file_size 1
  f.photo_updated_at nil
end