Factory.define :attached_document do |f|
    f.parent_id nil
    f.profile_id nil

    f.document_file_name "image"
    f.document_content_type "image/png"
    f.document_file_size nil
    f.document_updated_at nil
    f.created_at nil
    f.updated_at nil
    f.name "Bharti's Passport"
    f.document_type "Passport"
end